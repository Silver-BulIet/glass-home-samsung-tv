#!/bin/sh
# Puts the TV back: optionally deletes Glass Home, and prints the menu steps
# that undo each Samsung setting change. Nothing was ever uninstalled.
set -eu
root=$(cd "$(dirname "$0")/.." && pwd)
. "$root/scripts/tizen-env.sh"
printf 'Delete Glass Home from the TV (this also deletes its uploaded photos)? [y/N] '
read -r ans
if [ "${ans:-n}" = y ]; then
  sdb connect "$TV"
  tizen uninstall -s "$TV" -p "$APP_ID" || true
fi
cat <<'EOT'

Undo on the TV (values to restore are in your backup checklist/photos):
1. Left menu > Privacy Choices > Terms & Conditions, Privacy Policy: tick
   Viewing Information Services and Interest-Based Advertisements > OK.
2. Settings > Notification > gear: tick Samsung Promotion > OK.
3. Settings > All Settings > General & Privacy > Start Screen Options:
   Start with Smart Hub Home on, Autorun Last App off.
4. Home > For You > bottom > Media Options: Autoplay Sound back as before.
5. Apps > App Settings > Glass Home > Delete (if not removed above).
6. If DNS was ever changed: Network Status > IP Settings > DNS Setting >
   Get automatically.
7. Developer mode: Apps > App Settings > 1 2 3 4 5 > Off, restart the TV.
(The advertising-ID reset can't be undone and nothing depends on it.)
EOT
