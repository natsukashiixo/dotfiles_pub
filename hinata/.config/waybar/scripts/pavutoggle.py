#!/usr/bin/env python3
import sys
import subprocess
import time

def pavucontrol_running():
    """Checks if pavucontrol is running (concise) using pgrep -x."""
    # Use pgrep -x for exact command name match.
    # Returns 0 if found, non-zero if not.
    result = subprocess.run(
        ['pgrep', '-x', 'pavucontrol'],
        capture_output=True, text=True, check=False
    )
    return result.returncode == 0

if __name__ == '__main__':
    if pavucontrol_running():
        # Try standard kill (SIGTERM)
        subprocess.run(['killall', 'pavucontrol'], check=False)
        time.sleep(0.5) # Give it a moment to die gracefully
        # If still running, force kill (SIGKILL)
        if pavucontrol_running():
             subprocess.run(['killall', '-9', 'pavucontrol'], check=False)
        sys.exit(0) # Exit after killing attempts

    # Launch pavucontrol in the background using Popen if not running.
    subprocess.Popen(['pavucontrol'])
    sys.exit(0) # Exit after launching
