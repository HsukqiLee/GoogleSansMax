#!/system/bin/sh
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

for f in "$BASE_DIR"/action.sh "$BASE_DIR"/service.sh; do add_file "$f"; done
for f in "$BASE_DIR"/lib/*.sh; do add_file "$f"; done

add_file "$BASE_DIR"/module.prop
add_file "$BASE_DIR"/launcher.png
