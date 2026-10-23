#!/bin/sh
# Saves what can be read from the TV before any change: device ID, installed
# apps, TV info, and a checklist for the settings Samsung doesn't expose.
# Needs Developer Mode on and scripts/tizen-env.sh. Writes backups/<timestamp>/.
set -eu
root=$(cd "$(dirname "$0")/.." && pwd)
. "$root/scripts/tizen-env.sh"
out="$root/backups/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$out"; chmod 700 "$root/backups"
sdb connect "$TV" >/dev/null
sdb -s "$TV" shell 0 getduid        > "$out/duid.txt"        || true
sdb -s "$TV" shell 0 vd_applist     > "$out/vd_applist.txt"  || true
tizen version                       > "$out/tizen-cli.txt" 2>&1 || true
( cd "$root/tools" && TV_IP="$TV_IP" python3 tvremote.py info ) > "$out/tv-info.json" 2>&1 || true
cat > "$out/SETTINGS-CHECKLIST.md" <<'EOT'
# Photograph or note each setting BEFORE changing it (restore.sh prints the way back)
- [ ] Privacy Choices: Viewing Information Services = ____  Interest-Based Advertisements = ____
- [ ] Notification gear: Samsung Promotion = ____
- [ ] General & Privacy > Start Screen Options: Start with Smart Hub Home = ____  Autorun Last App = ____
- [ ] Home > For You > bottom: Autoplay Sound = ____
- [ ] Network Status > IP Settings > DNS Setting = ____ (left unchanged by this guide)
- [ ] Home row order (photo of the Home screen)
EOT
echo "Backup saved to $out"
echo "Now photograph the settings listed in SETTINGS-CHECKLIST.md."
