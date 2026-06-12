#!/system/bin/sh
# ==========================================
# 共享 awk 替换函数 (customize.sh + action.sh 共用)
# ==========================================

# ------------------------------------------
# font_fallback.xml patching
#   $1: TARGET_XML   font_fallback.xml 路径
#   $2: TMP_DIR      临时文件目录
#
#   FontListParser (Android 15+) doesn't properly distribute weight
#   requests across a VF range declared via supportedAxes="wght" on a
#   single <font> entry. Serif/monospace compress, CJK collapses.
#   Fix: explicit weight bucket entries with <axis> elements, same as
#   the old-schema approach in fonts.xml.
# ------------------------------------------
patch_font_fallback() {
    local TARGET_XML="$1"
    local TMP_DIR="$2"

    # --- sans-serif → Google Sans Flex VF (wght 1-1000) ---
    # GoogleSansFlex supportedAxes only accepts wght (slnt, not ital).
    # Single VF entry is sufficient for sans-serif (the default family).
    ui_print "  -> Replacing sans-serif with Google Sans Flex (wght 1-1000)..."
    cat > "$TMP_DIR/fb_sans_serif.xml" << 'FBEOF'
  <family name="sans-serif">
    <font supportedAxes="wght">
      GoogleSansFlex-Regular.ttf
    </font>
  </family>
FBEOF
    replace_named_family "sans-serif" "$TMP_DIR/fb_sans_serif.xml" "$TARGET_XML"

    # --- serif → Noto Serif VF: explicit weight buckets 100-900 ---
    if [ -f "$MODPATH/system/fonts/NotoSerif-VF.ttf" ]; then
        ui_print "  -> Replacing serif with Noto Serif (wght 100-900, normal+italic)..."
        echo '  <family name="serif">' > "$TMP_DIR/fb_serif.xml"
        for W in 100 200 300 400 500 600 700 800 900; do
            echo "    <font weight=\"$W\" style=\"normal\">NotoSerif-VF.ttf<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$TMP_DIR/fb_serif.xml"
            echo "    <font weight=\"$W\" style=\"italic\">NotoSerif-Italic-VF.ttf<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$TMP_DIR/fb_serif.xml"
        done
        echo '  </family>' >> "$TMP_DIR/fb_serif.xml"
        replace_named_family "serif" "$TMP_DIR/fb_serif.xml" "$TARGET_XML"
    fi

    # --- monospace → Noto Sans Mono VF: explicit weight buckets 100-900 ---
    # NotoSansMono has no italic/slant; italic entries omitted to match AOSP
    # (DroidSansMono.ttf) behavior: italic monospace falls through to sans-serif italic.
    if [ -f "$MODPATH/system/fonts/NotoSansMono-VF.ttf" ]; then
        ui_print "  -> Replacing monospace with Noto Sans Mono (wght 100-900)..."
        echo '  <family name="monospace">' > "$TMP_DIR/fb_mono.xml"
        for W in 100 200 300 400 500 600 700 800 900; do
            echo "    <font weight=\"$W\" style=\"normal\">NotoSansMono-VF.ttf<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$TMP_DIR/fb_mono.xml"
        done
        echo '  </family>' >> "$TMP_DIR/fb_mono.xml"
        replace_named_family "monospace" "$TMP_DIR/fb_mono.xml" "$TARGET_XML"
    fi

    # --- CJK: explicit weight buckets per language (sans 100-900, serif 200-900) ---
    ui_print "  -> Patching CJK with explicit weight buckets..."
    for LANG_SPEC in \
        "lang=\"zh-Hans\" index=2 prefix=sc" \
        "lang=\"zh-Hant,zh-Bopo\" index=3 prefix=tc" \
        "lang=\"ja\" index=0 prefix=jp" \
        "lang=\"ko\" index=1 prefix=kr"; do

        LANG_TAG=$(echo "$LANG_SPEC" | awk '{print $1}')
        INDEX=$(echo "$LANG_SPEC" | awk '{print $2}' | sed 's/index=//')
        PREFIX=$(echo "$LANG_SPEC" | awk '{print $3}' | sed 's/prefix=//')

        generate_fb_cjk_payload "$TMP_DIR/fb_cjk_payload.xml" "$LANG_TAG" "$INDEX" "$PREFIX"
        replace_cjk_family "<family $LANG_TAG>" "$TMP_DIR/fb_cjk_payload.xml" "$TARGET_XML"
    done

    # --- serif aliases: serif-bold(700) → full alias chain ---
    ui_print "  -> Expanding serif weight aliases..."
    sed -i 's/<alias name="serif-bold" to="serif" weight="700"[[:space:]]*\/>/<alias name="serif-thin" to="serif" weight="100" \/>\n<alias name="serif-light" to="serif" weight="300" \/>\n<alias name="serif-medium" to="serif" weight="400" \/>\n<alias name="serif-semi-bold" to="serif" weight="500" \/>\n<alias name="serif-bold" to="serif" weight="700" \/>\n<alias name="serif-black" to="serif" weight="900" \/>/g' "$TARGET_XML"
}

# ==========================================
# font_fallback.xml: generate CJK payload (sans + serif) with explicit weight buckets
#   $1: OUT          output file path
#   $2: LANG_TAG     e.g. lang="zh-Hans"
#   $3: INDEX        TTC index e.g. "2"
#   $4: PREFIX       e.g. "sc", "tc", "jp", "kr"
# ==========================================
generate_fb_cjk_payload() {
    local OUT="$1"
    local LANG_TAG="$2"
    local INDEX="$3"
    local PREFIX="$4"

    # CJK sans family: weight 100-900
    echo "  <family $LANG_TAG>" > "$OUT"
    for W in 100 200 300 400 500 600 700 800 900; do
        printf '    <font weight="%d" style="normal" index="%s" postScriptName="NotoSansCJK%s-Thin">NotoSansCJK-VF.otf.ttc<axis tag="wght" stylevalue="%d" /></font>\n' \
            "$W" "$INDEX" "$PREFIX" "$W" >> "$OUT"
    done
    echo "  </family>" >> "$OUT"

    # CJK serif family: weight 200-900
    echo "  <family $LANG_TAG>" >> "$OUT"
    for W in 200 300 400 500 600 700 800 900; do
        printf '    <font weight="%d" style="normal" index="%s" fallbackFor="serif" postScriptName="NotoSerifCJK%s-ExtraLight">NotoSerifCJK-VF.otf.ttc<axis tag="wght" stylevalue="%d" /></font>\n' \
            "$W" "$INDEX" "$PREFIX" "$W" >> "$OUT"
    done
    echo "  </family>" >> "$OUT"
}

# ==========================================
# 针对 CJK family 的块级替换
#   $1: TARGET_TAG  (如 <family lang="ja">)
#   $2: PAYLOAD_FILE
#   $3: TARGET_XML
# ==========================================
replace_cjk_family() {
    local TARGET_TAG="$1"
    local PAYLOAD_FILE="$2"
    local TARGET_XML="$3"

    awk -v tag="$TARGET_TAG" -v pfile="$PAYLOAD_FILE" '
    BEGIN { inblk = 0; buf = ""; payload = ""
        while ((getline line < pfile) > 0) { payload = payload line ORS }
        close(pfile)
    }
    (!inblk && index($0, tag) > 0) {
        inblk = 1
        buf = $0 ORS
        next
    }
    inblk {
        buf = buf $0 ORS
        if (index($0, "</family>") > 0) {
            if (buf ~ /Noto/ && buf ~ /CJK/) {
                printf "%s", payload
            } else {
                printf "%s", buf
            }
            inblk = 0
            buf = ""
        }
        next
    }
    { print }
    END { if (inblk) printf "%s", buf }
    ' "$TARGET_XML" > "${TARGET_XML}.tmp" && mv "${TARGET_XML}.tmp" "$TARGET_XML"
}

# ==========================================
# 替换 named family (如 sans-serif)
#   $1: FAMILY_NAME
#   $2: PAYLOAD_FILE
#   $3: TARGET_XML
# ==========================================
replace_named_family() {
    local FAMILY_NAME="$1"
    local PAYLOAD_FILE="$2"
    local TARGET_XML="$3"

    awk -v name="$FAMILY_NAME" -v pfile="$PAYLOAD_FILE" '
    BEGIN { inblk = 0; buf = ""; pat = "name=\"" name "\""
        payload = ""
        while ((getline line < pfile) > 0) { payload = payload line ORS }
        close(pfile)
    }
    (!inblk && index($0, pat) > 0) {
        inblk = 1
        buf = $0 ORS
        next
    }
    inblk {
        buf = buf $0 ORS
        if (index($0, "</family>") > 0) {
            printf "%s", payload
            inblk = 0
            buf = ""
        }
        next
    }
    { print }
    END { if (inblk) printf "%s", buf }
    ' "$TARGET_XML" > "${TARGET_XML}.tmp" && mv "${TARGET_XML}.tmp" "$TARGET_XML"
}
