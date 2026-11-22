#!/bin/sh
# Removes everything install.sh created. Remove the add-on itself from
# Thunderbird's Add-ons and Themes page.
for f in \
  "$HOME/.local/bin/sieve_launcher.py" \
  "$HOME/.mozilla/native-messaging-hosts/sieve_launcher.json" \
  "$HOME/.thunderbird/native-messaging-hosts/sieve_launcher.json"
do
  [ -e "$f" ] && rm -f "$f" && echo "Removed $f"
done

if [ -d "$HOME/.config/sieve-launcher" ]; then
  rm -rf "$HOME/.config/sieve-launcher" && echo "Removed $HOME/.config/sieve-launcher"
fi

# Clean up the registry folders only if they are now empty.
rmdir "$HOME/.mozilla/native-messaging-hosts" "$HOME/.thunderbird/native-messaging-hosts" 2>/dev/null
echo "Uninstall complete."
