#!/bin/sh
set -eu

ROOT="${1:-.}"
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

ui_print() { :; }
. "$ROOT/lib/awk.sh"

cat > "$TMP_DIR/fonts.xml" << 'EOF'
<familyset>
  <family name="sans-serif">
    <font>GoogleSansFlex-Regular.ttf</font>
  </family>
  <family lang="ja">
    <font>NotoSerifHentaigana.ttf</font>
  </family>
  <family>
    <font>NotoSansSymbols-Regular-Subsetted.ttf</font>
  </family>
</familyset>
EOF

cat > "$TMP_DIR/priority.xml" << 'EOF'
  <family>
    <font>GoogleSansMaxSymbolCombiningCompat.otf</font>
  </family>
EOF

cat > "$TMP_DIR/hentaigana.xml" << 'EOF'
  <family lang="ja">
    <font weight="400">NotoSerifHentaigana.ttf</font>
  </family>
EOF

insert_priority_fallback "$TMP_DIR/fonts.xml" "$TMP_DIR/priority.xml"
insert_priority_fallback "$TMP_DIR/fonts.xml" "$TMP_DIR/priority.xml"
replace_family_by_keyword \
    '<family lang="ja">' \
    'NotoSerifHentaigana' \
    "$TMP_DIR/hentaigana.xml" \
    "$TMP_DIR/fonts.xml"

[ "$(grep -c 'GoogleSansMax priority fallback start' "$TMP_DIR/fonts.xml")" -eq 1 ]
[ "$(grep -c 'GoogleSansMaxSymbolCombiningCompat.otf' "$TMP_DIR/fonts.xml")" -eq 1 ]
[ "$(grep -c 'NotoSerifHentaigana.ttf' "$TMP_DIR/fonts.xml")" -eq 1 ]

COMPAT_LINE=$(grep -n 'GoogleSansMaxSymbolCombiningCompat.otf' "$TMP_DIR/fonts.xml" | cut -d: -f1)
SYMBOLS_LINE=$(grep -n 'NotoSansSymbols-Regular-Subsetted.ttf' "$TMP_DIR/fonts.xml" | cut -d: -f1)
[ "$COMPAT_LINE" -lt "$SYMBOLS_LINE" ]

cat > "$TMP_DIR/unicode-only.xml" << 'EOF'
<familyset>
  <family name="sans-serif">
    <font>GoogleSansFlex-Regular.ttf</font>
  </family>
  <!-- Start Inject Fragment -->
  <family>
    <font>NotoSansSuper.otf</font>
  </family>
</familyset>
EOF

insert_priority_fallback "$TMP_DIR/unicode-only.xml" "$TMP_DIR/priority.xml"
COMPAT_LINE=$(grep -n 'GoogleSansMaxSymbolCombiningCompat.otf' "$TMP_DIR/unicode-only.xml" | cut -d: -f1)
SUPER_LINE=$(grep -n 'NotoSansSuper.otf' "$TMP_DIR/unicode-only.xml" | cut -d: -f1)
[ "$COMPAT_LINE" -lt "$SUPER_LINE" ]

cat > "$TMP_DIR/no-anchor.xml" << 'EOF'
<familyset>
  <family name="sans-serif">
    <font>GoogleSansFlex-Regular.ttf</font>
  </family>
</familyset>
EOF
cp "$TMP_DIR/no-anchor.xml" "$TMP_DIR/no-anchor.expected.xml"
if insert_priority_fallback "$TMP_DIR/no-anchor.xml" "$TMP_DIR/priority.xml"; then
    exit 1
fi
cmp "$TMP_DIR/no-anchor.expected.xml" "$TMP_DIR/no-anchor.xml"

PYTHON=""
for candidate in python3 python python.exe; do
    if command -v "$candidate" >/dev/null 2>&1; then
        PYTHON="$candidate"
        break
    fi
done
[ -n "$PYTHON" ]

"$PYTHON" - "$TMP_DIR/fonts.xml" "$TMP_DIR/unicode-only.xml" << 'PY'
import sys
from xml.etree import ElementTree

for path in sys.argv[1:]:
    ElementTree.parse(path)
PY

sh "$ROOT/scripts/gen_manifest.sh" "$ROOT" "$TMP_DIR/manifest.txt"
for required in \
    action.sh \
    service.sh \
    uninstall.sh \
    lib/awk.sh \
    config/fonts_fragment.xml \
    config/fonts_priority_fragment.xml \
    scripts/gen_manifest.sh; do
    grep -Fq "${required}|" "$TMP_DIR/manifest.txt"
done

! grep -Fq 'module.prop|' "$TMP_DIR/manifest.txt"
! grep -Fq 'lib/lib.sh|' "$TMP_DIR/manifest.txt"
! grep -Fq 'scripts/strip_font_cmap.py|' "$TMP_DIR/manifest.txt"
