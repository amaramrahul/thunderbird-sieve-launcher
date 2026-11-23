#!/bin/sh
# Installs (or removes) the native helper for the Sieve Editor Launcher add-on
# (Thunderbird 140+).
#
# Usage:
#   ./install.sh ["command to start your sieve editor"]   (default: sieveeditor)
#   ./install.sh --uninstall
#   ./install.sh --help
set -e

LIB_DIR="$HOME/.local/lib/sieve-launcher"
BIN="$LIB_DIR/sieve_launcher.py"
LEGACY_BIN="$HOME/.local/bin/sieve_launcher.py"
CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/sieve-launcher"
HOST_DIRS="$HOME/.thunderbird/native-messaging-hosts $HOME/.mozilla/native-messaging-hosts"

usage() {
  sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'
}

uninstall() {
  for f in "$BIN" "$LEGACY_BIN"; do
    if [ -e "$f" ]; then rm -f "$f" && echo "Removed $f"; fi
  done
  for d in $HOST_DIRS; do
    if [ -e "$d/sieve_launcher.json" ]; then
      rm -f "$d/sieve_launcher.json" && echo "Removed $d/sieve_launcher.json"
    fi
  done
  if [ -d "$CONF_DIR" ]; then rm -rf "$CONF_DIR" && echo "Removed $CONF_DIR"; fi

  # Clean up directories only if they are now empty.
  rmdir "$LIB_DIR" 2>/dev/null || true
  for d in $HOST_DIRS; do rmdir "$d" 2>/dev/null || true; done
  echo "Uninstall complete. Remove the add-on itself from Thunderbird's Add-ons and Themes page."
}

case "${1:-}" in
  -h|--help) usage; exit 0 ;;
  --uninstall) uninstall; exit 0 ;;
  -*) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
esac

CMD="${1:-sieveeditor}"
DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$LIB_DIR" "$CONF_DIR"
cp "$DIR/sieve_launcher.py" "$BIN"
chmod +x "$BIN"
printf '%s\n' "$CMD" > "$CONF_DIR/command"
rm -f "$LEGACY_BIN"

# Register the helper in both per-user locations Thunderbird may search.
for d in $HOST_DIRS; do
  mkdir -p "$d"
  cat > "$d/sieve_launcher.json" <<EOF
{
  "name": "sieve_launcher",
  "description": "Launches an external Sieve editor",
  "path": "$BIN",
  "type": "stdio",
  "allowed_extensions": ["thunderbird-sieve-launcher@amaramrahul.github.io"]
}
EOF
done

if ! command -v "${CMD%% *}" >/dev/null 2>&1 && [ ! -x "${CMD%% *}" ]; then
  echo "Warning: '${CMD%% *}' was not found on your PATH."
fi
echo "Helper installed. Editor command: $CMD"
echo "Change it any time in $CONF_DIR/command"
