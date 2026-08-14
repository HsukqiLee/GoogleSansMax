#!/bin/sh
# Copyright (C) 2025 Hsukqi Lee <https://github.com/HsukqiLee>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

# Generate font manifest.txt
# Used by both CI (release.yml) and on-device action.sh (hot-update).
#
# Usage: gen_manifest.sh <base_dir> <output>
#   base_dir  = module root (e.g. /data/adb/modules/GoogleSansMax or build_dir)
#   output    = path for generated manifest.txt

BASE_DIR="${1:-.}"
OUTPUT="${2:-$BASE_DIR/lib/manifest.txt}"

HAS_SHA256=0
command -v sha256sum >/dev/null 2>&1 && HAS_SHA256=1

add_file() {
    local f="$1"
    [ -f "$f" ] || return

    local NAME="${f#$BASE_DIR/}"
    NAME="${NAME#/}"

    local SIZE
    SIZE=$(wc -c < "$f" 2>/dev/null) || return

    local HASH="0000000000000000000000000000000000000000000000000000000000000000"
    if [ "$HAS_SHA256" -eq 1 ]; then
        HASH=$(sha256sum "$f" 2>/dev/null | cut -d' ' -f1)
        [ -z "$HASH" ] && HASH="0000000000000000000000000000000000000000000000000000000000000000"
    fi

    echo "$NAME|$HASH|$SIZE" >> "$OUTPUT"
}

mkdir -p "$(dirname "$OUTPUT")"

echo "# GoogleSansMax Manifest" > "$OUTPUT"
echo "# Auto-generated. Do not edit manually." >> "$OUTPUT"
echo "# Format: filename|sha256|filesize" >> "$OUTPUT"
echo "#" >> "$OUTPUT"

for f in "$BASE_DIR"/system/fonts/*; do
    [ -f "$f" ] && add_file "$f"
done

for f in "$BASE_DIR"/system/fonts/unicode/*; do
    [ -f "$f" ] && add_file "$f"
done

# Only include files that survive customize.sh cleanup.
# lib/*.sh (except awk.sh) and font-source/ are deleted during install;
# tests/, tmp/, and scripts/*.py are also removed.
for f in "$BASE_DIR"/action.sh "$BASE_DIR"/service.sh "$BASE_DIR"/uninstall.sh; do add_file "$f"; done
add_file "$BASE_DIR"/lib/awk.sh
for f in "$BASE_DIR"/config/*.xml; do add_file "$f"; done
add_file "$BASE_DIR"/scripts/gen_manifest.sh

add_file "$BASE_DIR"/launcher.png
add_file "$BASE_DIR"/banner.png
