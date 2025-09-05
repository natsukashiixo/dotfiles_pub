#!/usr/bin/env python3
import sys
# No need for subprocess if we remove the pkill line
# import subprocess

class Level:
  """Represents the Roman numeral symbols for a specific place value."""
  def __init__(self, i, v, x):
    self.i = i  # Symbol for 1 (e.g., I, X, C)
    self.v = v  # Symbol for 5 (e.g., V, L, D)
    self.x = x  # Symbol for 10 (e.g., X, C, M)

# Define the levels for ones, tens, and hundreds place values
levels = []
levels.append(Level('I', 'V', 'X'))  # Level 0: Units (I, V, X)
levels.append(Level('X', 'L', 'C'))  # Level 1: Tens (X, L, C)
levels.append(Level('C', 'D', 'M'))  # Level 2: Hundreds (C, D, M)

def calc_digit(d, l):
  """
  Calculates the Roman numeral representation of a single digit at a specific level.

  Args:
    d: The digit (0-9).
    l: The level (0 for units, 1 for tens, 2 for hundreds, 3+ for thousands).

  Returns:
    The Roman numeral string for the digit at the given level.
  """
  if l > 2:
    # For thousands and above, repeat 'M' (or the next level's 'i' symbol
    # if the levels list were extended, but the original JS only uses 'M')
    # The original JS code has a potential logical error here for levels > 3
    # as it always repeats 'M'. A more complete Roman numeral converter
    # would need additional levels and logic for larger numbers.
    # Based *strictly* on the provided JS, we replicate the 'M' repetition.
    # This logic is really only correct for l=3 (thousands place) for d > 0.
    if d == 0: # Handle 0 explicitly for levels > 2
        return ''
    # For l=3, 10**(3-3) is 1, so it repeats 'M' 'd' times.
    # For l=4, 10**(4-3) is 10, so it repeats 'M' d*10 times (incorrect for standard Roman).
    # We are translating the original JS logic directly.
    return 'M' * (d * (10**(l - 3)))
  elif d == 0:
      return '' # No Roman numeral for 0 in a specific place value if it's not the only digit (e.g., 10 is X, not X then nothing)
                 # However, the original JS seems to return '' for d=0 at any level <= 2, which is correct for internal digit calculation.
  elif d == 1:
    return levels[l].i
  elif d == 2:
    return levels[l].i * 2
  elif d == 3:
    return levels[l].i * 3
  elif d == 4:
    return levels[l].i + levels[l].v
  elif d == 5:
    return levels[l].v
  elif d == 6:
    return levels[l].v + levels[l].i
  elif d == 7:
    return levels[l].v + levels[l].i * 2
  elif d == 8:
    return levels[l].v + levels[l].i * 3
  elif d == 9:
    return levels[l].i + levels[l].x
  else:
    return '' # Should not happen for digits 0-9

def to_roman(n_str):
  """
  Converts a number string to its Roman numeral representation.

  Args:
    n_str: The input number as a string.

  Returns:
    The Roman numeral representation as a string.
  """
  # Handle empty string input gracefully
  if not n_str:
      return ''
  try:
      # Ensure input is a valid number string
      int(n_str)
  except ValueError:
      # Return original string or an error indicator if conversion fails
      return n_str # Or return "Invalid Input"

  r = ''
  n_len = len(n_str)
  for c in range(n_len):
    # Convert character digit to integer
    digit = int(n_str[c])
    # Calculate the level based on the position of the digit
    level = n_len - c - 1
    r += calc_digit(digit, level)
  return r

if __name__ == '__main__':
    # sys.argv[0] is the script name, sys.argv[1] is the first argument
    # Check if an argument is provided
    if len(sys.argv) > 1:
        workspace_id_str = sys.argv[1]
        roman_numeral = to_roman(workspace_id_str)
        print(roman_numeral)
    else:
        # Handle cases where no workspace ID is passed (e.g., direct script execution)
        # You might print a default or an error message depending on desired behavior
        # print("Error: No workspace ID provided")
        pass # Waybar should always provide an ID, so this case might not be necessary in practice
