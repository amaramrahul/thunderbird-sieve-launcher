#!/usr/bin/env python3
"""Native messaging helper: starts the Sieve editor when Thunderbird asks.

The command to run is read from ~/.config/sieve-launcher/command
(one line, e.g.  sieveeditor   or   /home/me/Apps/sieve.AppImage).
"""
import json
import os
import shlex
import struct
import subprocess
import sys

CONFIG = os.path.expanduser("~/.config/sieve-launcher/command")
DEFAULT = "sieveeditor"


def read_msg():
    raw = sys.stdin.buffer.read(4)
    if len(raw) < 4:
        return None
    length = struct.unpack("=I", raw)[0]
    return json.loads(sys.stdin.buffer.read(length))


def send_msg(obj):
    data = json.dumps(obj).encode()
    sys.stdout.buffer.write(struct.pack("=I", len(data)) + data)
    sys.stdout.buffer.flush()


def main():
    msg = read_msg()
    if not msg or msg.get("action") != "launch":
        send_msg({"ok": False, "error": "unknown request"})
        return
    try:
        with open(CONFIG) as f:
            cmd = f.read().strip() or DEFAULT
    except FileNotFoundError:
        cmd = DEFAULT
    try:
        subprocess.Popen(
            shlex.split(cmd),
            stdin=subprocess.DEVNULL,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session=True,  # keep editor running independently
        )
        send_msg({"ok": True})
    except Exception as e:
        send_msg({"ok": False, "error": str(e)})


if __name__ == "__main__":
    main()
