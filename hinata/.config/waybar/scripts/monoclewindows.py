#!/usr/bin/python3
import sys
import subprocess, json, re

# regex pattern designed to split "not needed - whats needed" pattern into 2 groups
pattern = re.compile(r'^(.*) - (.*)$')

def run_cmd(cmd):
    r = subprocess.run(cmd, shell=True, text=True, capture_output=True)
    if r.returncode != 0:
        raise RuntimeError(r.stderr or "cmd failed")
    return r.stdout

# get windows as array
clients_json = run_cmd('hyprctl clients -j | jq -c \'[.[] | select(.workspace.name == "monoclevert")]\'')
monocle_windows = json.loads(clients_json)

# get active window as json object/dict
active_window = sorted(monocle_windows, key=lambda x: x.get('focusHistoryID', 0))[0]

# rudimentary mapping of icons
SHARKORD="󱢺"; HELIUM=""; TERMINALEMU=""; FIREFOX="󰈹"
DISCORD=""; MATRIX="󰘨"; TELEGRAM=""; SIGNAL=""; IDE=""

# hopefully matches IDE names, havent double checked yet
IDEs = ['vscode','rider','cursor','zed','pycharm', "nvim"]

def choose_icon(windowinfo: dict):
    wc = (windowinfo.get('class') or "").casefold()
    wt = (windowinfo.get('title') or "").casefold()
    wi = (windowinfo.get('initialTitle') or "").casefold()

    # minor warning this checks substrings and is very loose so could potentially assign the wrong icons in some cases
    # i.e. lets say you're on the sharkord github repo reading the changelog, since the string sharkord is in the title it will return the sharkord icon
    # checking in order of class > initialTitle > title is a minor protection strat but not foolproof
    for s in (wc, wi, wt):
        if "sharkord" in s: return SHARKORD
        if "helium" in s: return HELIUM
        if "ghostty" in s: return TERMINALEMU
        if "firefox" in s: return FIREFOX
        if "discord" in s: return DISCORD
        if ".element" in s: return MATRIX #unverified name atm
        if "telegram" in s: return TELEGRAM
        if ".signal" in s: return SIGNAL #unverified name atm
        if any(ide in s for ide in IDEs): return IDE

    # attempt a fallback using regex
    
    m = pattern.match(wi)
    if m:
        right = m.group(2).strip()
        # if there is only one word, return it, aka "Browser tab name - Chromium" return "Chromium"
        if len(right.split()) == 1:
            return right
        # otherwise if there is more than one word, return the first letter of each word as uppercase
        # should turn for example "hierophant - Path of Building" into "POB"
        if right:
            short = "".join(word[0].upper() for word in right.split() if word)
            if short:
                return short

    # if all else fails, truncate the active title down to 8 characters
    return wt[:8]

if monocle_windows:
    # first sort windows in ascending order to get latest/active window
    monocle_windows.sort(key=lambda x: x.get('focusHistoryID', 0))
    # poop it because we dont need it
    monocle_windows.pop(0)
    # when using hyprctl dispatcher cyclenext it cycles through windows in a descending order based on focusHistoryID, so remaining objects should be sorted in reverse
    monocle_windows.sort(key=lambda x: x.get('focusHistoryID', 0), reverse=True)


icons = [choose_icon(w) for w in monocle_windows]
SORTEDICONS = " ".join(icons)
SORTEDICONS += " " # looked weird without trailing space
ACTIVEICON = choose_icon(active_window)

# json object based on waybar specs. for use with format and classes in css
JSON_OUT = {"alt": ACTIVEICON, "text": SORTEDICONS, "class": "activeicon"} # ???
# The class parameter also accepts an array of strings. < from da fucking docs
# but it doesn't let you map that shit? wtf am i missing or is wiki maintainer smoking crack
# array should imply that classes are assigned in the order 
# even if im renaming classes so they perfectly map to their keys, one always supercedes the other. wat

# print flat json object to stdout for waybar to parse
print(json.dumps(JSON_OUT, ensure_ascii=False))
sys.exit(0)