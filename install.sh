#!/bin/sh
# Installs the native helper for the Sieve Editor Launcher add-on (Thunderbird 140+).
# Usage: ./install.sh ["command to start your sieve editor"]   (default: sieveeditor)
set -e
CMD="${1:-sieveeditor}"
DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$HOME/.local/bin/sieve_launcher.py"

mkdir -p "$HOME/.local/bin" "$HOME/.config/sieve-launcher"
cp "$DIR/sieve_launcher.py" "$BIN"
chmod +x "$BIN"
printf '%s\n' "$CMD" > "$HOME/.config/sieve-launcher/command"

# Register the helper in both per-user locations Thunderbird may search.
for d in "$HOME/.mozilla/native-messaging-hosts" "$HOME/.thunderbird/native-messaging-hosts"; do
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
echo "Change it any time in ~/.config/sieve-launcher/command"
