#!/system/bin/sh
# ==========================================
# 共享 awk 替换函数 (customize.sh + action.sh 共用)
# ==========================================

# ------------------------------------------
# font_fallback.xml (新 schema: supportedAxes 单条 VF)
#   $1: TARGET_XML   font_fallback.xml 路径
#   $2: TMP_DIR      临时文件目录
# ------------------------------------------
patch_font_fallback() {
    local TARGET_XML="$1"
    local TMP_DIR="$2"

    # --- sans-serif → Google Sans Flex VF (wght 1-1000) ---
    # NOTE: supportedAxes only accepts "wght" and "ital" (Android V+).
    # GoogleSansFlex uses slnt, not ital, so we declare wght only.
    # Italic uses synthetic slant which is visually acceptable.
    ui_print "  -> Replacing sans-serif with Google Sans Flex (VF wght)..."
    cat > "$TMP_DIR/fb_sans_serif.xml" << 'FBEOF'
  <family name="sans-serif">
    <font supportedAxes="wght">
      GoogleSansFlex-Regular.ttf
    </font>
  </family>
FBEOF
    replace_named_family "sans-serif" "$TMP_DIR/fb_sans_serif.xml" "$TARGET_XML"

    # --- serif → Noto Serif VF (wght 100-900) ---
    if [ -f "$MODPATH/system/fonts/NotoSerif-VF.ttf" ]; then
        ui_print "  -> Replacing serif with Noto Serif (VF wght)..."
        cat > "$TMP_DIR/fb_serif.xml" << 'FBEOF'
  <family name="serif">
    <font supportedAxes="wght">
      NotoSerif-VF.ttf
    </font>
  </family>
FBEOF
        replace_named_family "serif" "$TMP_DIR/fb_serif.xml" "$TARGET_XML"
    fi

    # --- monospace → Noto Sans Mono VF (wght 1-1000) ---
    if [ -f "$MODPATH/system/fonts/NotoSansMono-VF.ttf" ]; then
        ui_print "  -> Replacing monospace with Noto Sans Mono (VF wght)..."
        cat > "$TMP_DIR/fb_mono.xml" << 'FBEOF'
  <family name="monospace">
    <font supportedAxes="wght">
      NotoSansMono-VF.ttf
    </font>
  </family>
FBEOF
        replace_named_family "monospace" "$TMP_DIR/fb_mono.xml" "$TARGET_XML"
    fi

    # --- CJK: DO NOT PATCH ---
    # font_fallback.xml CJK entries use postScriptName matching against the
    # TTC collection. Replacing them with VF names (NotoSansCJK-VF.otf.ttc,
    # locale-specific postScriptNames like NotoSansCJKsc-Thin) causes the
    # FontListParser to hang during boot because the postScriptNames inside
    # the VF TTC may not match. Keep the original CJK entries untouched.
    # The CJK weight expansion (1-1000) is handled by fonts.xml instead.

    # --- serif aliases: serif-bold(700) → full alias chain ---
    ui_print "  -> Expanding serif weight aliases..."
    sed -i 's/<alias name="serif-bold" to="serif" weight="700"[[:space:]]*\/>/<alias name="serif-thin" to="serif" weight="100" \/>\n<alias name="serif-light" to="serif" weight="300" \/>\n<alias name="serif-medium" to="serif" weight="400" \/>\n<alias name="serif-semi-bold" to="serif" weight="500" \/>\n<alias name="serif-bold" to="serif" weight="700" \/>\n<alias name="serif-black" to="serif" weight="900" \/>/g' "$TARGET_XML"
}

# 针对 CJK family 的块级替换
#   $1: TARGET_TAG  (如 lang="ja")
#   $2: PAYLOAD_FILE
#   $3: TARGET_XML
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

# 针对非 CJK 家族的块级替换 (如 Hentaigana)
#   $1: TARGET_TAG  (如 lang="ja")
#   $2: TARGET_KEYWORD (如 NotoSerifHentaigana)
#   $3: PAYLOAD_FILE
#   $4: TARGET_XML
replace_family_by_keyword() {
    local TARGET_TAG="$1"
    local TARGET_KEYWORD="$2"
    local PAYLOAD_FILE="$3"
    local TARGET_XML="$4"

    awk -v tag="$TARGET_TAG" -v keyword="$TARGET_KEYWORD" -v pfile="$PAYLOAD_FILE" '
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
            if (index(buf, keyword) > 0) {
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

# 替换 named family (如 sans-serif)
#   $1: FAMILY_NAME
#   $2: PAYLOAD_FILE
#   $3: TARGET_XML
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
