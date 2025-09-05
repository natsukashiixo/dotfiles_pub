#!/usr/bin/env python3
import subprocess

def call_fcitx():
    a = subprocess.run(
    ['fcitx5-remote', '-n'],
    capture_output=True,
    text=True,
    check=True)
    return a.stdout.strip()

def map_lang(stdo: str):
    match stdo:
        case 'keyboard-se':
            return 'Swe'
        case 'mozc':
            return '日本語'
        case _:
            return 'wtf?'

if __name__ == '__main__':
    lang = call_fcitx()
    print(map_lang(lang))
