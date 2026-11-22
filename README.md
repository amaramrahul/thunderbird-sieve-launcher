# Thunderbird Sieve Launcher

## Overview

A small Thunderbird add-on that adds a **Sieve** toolbar button and a
**Ctrl+Alt+S** shortcut to open an external Sieve editor.

Thunderbird add-ons can't start programs themselves, so the add-on talks to a
tiny Python helper through Thunderbird's
[native messaging](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Native_messaging)
API, and the helper starts the editor.

```
addon/              the Thunderbird add-on (button + shortcut)
sieve_launcher.py   native helper that starts the editor
install.sh          installs and registers the helper
uninstall.sh        removes everything install.sh created
build.sh            packages addon/ into sieve-launcher.xpi
```

## Requirements

- Linux
- Thunderbird 140 or newer, installed from your distribution's packages.
  Sandboxed builds (Flatpak, Snap) may block native messaging.
- Python 3
- A Sieve editor. The default is `sieveeditor` (KDE's Sieve Editor).

## Installing

1. Install the helper, optionally giving the command that starts your editor:

   ```sh
   ./install.sh                         # uses sieveeditor
   ./install.sh ~/Apps/sieve.AppImage   # or any other command
   ```

2. Build the add-on:

   ```sh
   ./build.sh
   ```

3. In Thunderbird, open **Add-ons and Themes → ⚙ → Install Add-on From File…**
   and choose `sieve-launcher.xpi`. If Thunderbird refuses because the add-on
   is unsigned, load it via **Tools → Developer Tools → Debug Add-ons → Load
   Temporary Add-on** instead (it then lasts until Thunderbird restarts).

## Usage

Click the **Sieve** button or press **Ctrl+Alt+S**. If the button is not on the
toolbar, right-click the toolbar, choose **Customize**, and drag it in.

To change the editor, edit `~/.config/sieve-launcher/command` (one line).

If nothing happens, check **Tools → Developer Tools → Error Console** for
messages from the add-on.

## Testing

Check the helper without Thunderbird by sending it a launch message. This
starts your configured editor and prints `{"ok": true}`:

```sh
printf '\x14\x00\x00\x00{"action": "launch"}' | ~/.local/bin/sieve_launcher.py
```

## Uninstalling

Remove the add-on from **Add-ons and Themes**, then run:

```sh
./uninstall.sh
```

## License

MIT. See [LICENSE](LICENSE).
