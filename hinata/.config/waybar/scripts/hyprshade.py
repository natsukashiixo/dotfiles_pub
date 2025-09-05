#!/usr/bin/env python3

import sys
import subprocess
import time
import fcntl
import os

def parse_args(args: list) -> tuple:
    """
    Set or get gamma and color temperature through hyprsunset IPC socket.
    """

    if not args:
        print("Set or get gamma and color temperature through hyprsunset IPC socket")
        print("Usage: hyprshade.py <gamma/temperature> [+-][value] [toggle]")
        sys.exit(1)

    cmd = args[0]
    delta = args[1] if len(args) > 1 else None
    toggle = args[2] if len(args) > 2 else None

    if cmd not in ["gamma", "temperature"]:
        print(f"Error: Invalid command '{cmd}'. Must be 'gamma' or 'temperature'.")
        sys.exit(1)
        return

    return cmd, delta, toggle

def get_current_value(cmd) -> int:
    try:
        # Get current value
        current_process = subprocess.run(
            ["hyprctl", "hyprsunset", cmd],
            capture_output=True,
            text=True,
            check=True
        )
        current_raw = current_process.stdout.strip()
        try:
            # Attempt to convert to float for comparison
            current_fmt = f"{float(current_raw):.0f}"
        except ValueError:
            current_fmt = 0 # Handle cases where output isn't a number
        finally:
            return int(current_fmt)

    except subprocess.CalledProcessError as e:
            print(f"Error getting current value with 'hyprctl hyprsunset {cmd}': {e}", file=sys.stderr)
            sys.exit(1)
    except ValueError:
            print(f"Warning: Could not parse current value '{current_raw}' as a number for toggle comparison.", file=sys.stderr)
            return 0


def toggle_value(current_fmt, delta):
    if current_fmt == delta:
        if cmd == "gamma":
            delta = "100"
        else:
            delta = "6300"
    return delta

#if delta is not None:
def lock_and_queue(sig):
    # Rate limit and queue commands to workaround potential issues (e.g., with Nvidia)
    lock_file_path = "/tmp/sunset.lock"
    try:
        # Ensure the lock file exists
        if not os.path.exists(lock_file_path):
                open(lock_file_path, 'a').close() # Create the file if it doesn't exist

        with open(lock_file_path, 'w') as lock_file:
            # Acquire an exclusive lock, non-blocking. If failed, the next call waits.
            # This effectively queues the commands.
            fcntl.flock(lock_file, fcntl.LOCK_EX)
            time.sleep(0.1) # Short sleep as in the original script

        # Tell waybar to update after a change
        try:
            # Find waybar process and send signal
            # This is a bit more complex than pkill. We'll need to find the PID.
            # A simpler approach might be to assume waybar listens on a socket
            # or uses a file, but replicating pkill SIGRTMIN+LEN is tricky
            # without external tools or deeper process inspection.
            # Let's use a best effort approach by calling pkill directly via subprocess.
            # This might require pkill to be available in the environment.
            subprocess.run(["pkill", "-SIGRTMIN+{}".format(sig), "waybar"], check=False)
        except FileNotFoundError:
            print("Warning: 'pkill' command not found. Cannot signal waybar.", file=sys.stderr)
        except Exception as e:
                print(f"Warning: Could not signal waybar: {e}", file=sys.stderr)

    except IOError as e:
        print(f"Error acquiring lock file {lock_file_path}: {e}", file=sys.stderr)
        # Continue without the lock, but warn
        print("Warning: Could not acquire lock. Continuing without rate limiting.", file=sys.stderr)
    except Exception as e:
        print(f"An unexpected error occurred during locking or signaling: {e}", file=sys.stderr)

def execute_command(cmd, value_to_set, sig_for_format): # Renamed delta to value_to_set for clarity
    """
    Executes the hyprctl hyprsunset command to set a value and prints the result.
    """
    try:
        # Execute the hyprctl command with the value to set
        command = ["hyprctl", "hyprsunset", cmd, str(value_to_set)] # Pass the value as an argument

        result_process = subprocess.run(
            command,
            capture_output=True, # <--- FIX: Capture the output
            text=True,
            check=True # Check for non-zero exit code
        )
        num_raw = result_process.stdout.strip() # <--- This should no longer be None

        # Format and print the output
        try:
            num_float = float(num_raw)
            # Use f-string formatting for precision and field width
            # The original used printf "%$LEN.0f", which means a minimum width of $LEN
            # and 0 decimal places.
            fmt_string = f"{{:{sig_for_format}.0f}}" # Use sig_for_format for width
            fmt_num = fmt_string.format(num_float)
            print(fmt_num)
        except ValueError:
            # If the output isn't a number, print it as is
            print(num_raw)

    except subprocess.CalledProcessError as e:
        print(f"Error executing 'hyprctl hyprsunset {' '.join(command)}': {e}", file=sys.stderr)
        # Check if stderr is not None before stripping
        if e.stderr:
             print(f"Stderr: {e.stderr.strip()}", file=sys.stderr)
        else:
             print("Stderr: (No stderr output captured)", file=sys.stderr)
        sys.exit(1)
    except FileNotFoundError:
        print("Error: 'hyprctl' command not found. Is Hyprland installed and in your PATH?", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"An unexpected error occurred: {e}", file=sys.stderr)
        sys.exit(1)

def clamp_vals(cmd, new_val) -> int:
    if cmd == "gamma":
        if new_val < 10:
            return 10
        elif new_val > 100:
            return 100
        else:
            return new_val
    else:
        if new_val < 1000:
            return 1000
        elif new_val > 20000:
            return 20000
        else:
            return new_val

if __name__ == "__main__":
    args = sys.argv[1:]
    cmd, delta_str, toggle_str = parse_args(args) # Renamed delta and toggle for clarity

    if cmd == "gamma":
        sig = 3
    else:
        sig = 4 # Use this sig for formatting and pkill signal

    # Handle the "get" case (only command provided)
    if delta_str is None and toggle_str is None:
        current_value = get_current_value(cmd)
        fmt_string = f"{{:{sig}.0f}}" # Use sig for formatting width
        print(fmt_string.format(current_value))
        sys.exit(0) # Exit after printing current value

    # Handle "set" or "toggle" cases
    current_value = get_current_value(cmd) # Need current value for relative changes or toggle
    target_value = None

    if toggle_str is not None:
        if delta_str is None:
             print(f"Error: Toggle command requires a value argument.", file=sys.stderr)
             sys.exit(1)
        try:
            toggle_against_val = int(delta_str)
        except ValueError:
             print(f"Error: Invalid toggle value '{delta_str}'. Must be an integer.", file=sys.stderr)
             sys.exit(1)

        if current_value == toggle_against_val:
            target_value = (100 if cmd == "gamma" else 6300) # Toggle to default
        else:
            target_value = toggle_against_val # Toggle to the provided value

    else: # Not a toggle, handle absolute or relative set
        if delta_str is None: # Should be caught by the check above, but safeguard
            print("Internal Error: Should have handled get case.", file=sys.stderr)
            sys.exit(1)
        try:
            if delta_str.startswith('+'):
                target_value = current_value + int(delta_str[1:])
            elif delta_str.startswith('-'):
                target_value = current_value - int(delta_str[1:])
            else:
                target_value = int(delta_str) # Absolute value
        except ValueError:
            print(f"Error: Invalid value '{delta_str}'. Must be an integer or start with '+' or '-'.", file=sys.stderr)
            sys.exit(1)


    target_value = clamp_vals(cmd, target_value)

    # Lock and queue and execute the command to SET the value
    lock_and_queue(sig) # Use the correct sig for the pkill signal
    execute_command(cmd, target_value, sig) # <--- FIX: Pass target_value and sig correctly
