#!/system/bin/sh
API=$(getprop ro.build.version.sdk)

ui_print "*********************************"
ui_print " Google Sans & Noto CJK Module "
ui_print "*********************************"

if [ "$API" -lt 26 ]; then
  abort "! Minimum Android 8.0 (API 26) required."
fi

if command -v magisk > /dev/null; then
    MAGISK_PATH="$(magisk --path 2>/dev/null)"
    MIRRORPATH="$MAGISK_PATH/.magisk/mirror"
    if [ ! -d "$MIRRORPATH/system" ]; then
        MIRRORPATH=""
    fi
else
    unset MIRRORPATH
fi

# ==========================================
# 标准字重档位 (符合 AOSP 可变字体规范)
#   可变字体无需逐 1 步进; Minikin 按"就近匹配"选择最接近的 weight 条目,
#   再应用该条目的 axis stylevalue。需精确字重的 App 用 fontVariationSettings
#   运行时直接设置轴值,绕过 fonts.xml 字重桶。
#   列出标准桶 (100-900) + 端点 (1000) 即可覆盖所有标准请求。
# ==========================================
WEIGHTS="100 200 300 400 500 600 700 800 900 1000"

# ==========================================
# 加载共享 awk 替换函数
# ==========================================
. "$MODPATH/lib/awk.sh"

# ==========================================
# 生成 sans-serif (Google Sans Flex 100-1000) XML
# ==========================================
generate_sans_serif_xml() {
    local OUT="$1"
    echo '    <family name="sans-serif">' > "$OUT"
    for W in $WEIGHTS; do
        echo "        <font weight=\"$W\" style=\"normal\">GoogleSansFlex-Regular.ttf<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$OUT"
        echo "        <font weight=\"$W\" style=\"italic\">GoogleSansFlex-Regular.ttf<axis tag=\"wght\" stylevalue=\"$W\" /><axis tag=\"slnt\" stylevalue=\"-10\" /></font>" >> "$OUT"
    done
    echo '    </family>' >> "$OUT"
}

# ==========================================
# 生成 monospace (Noto Sans Mono 100-1000) XML
# ==========================================
generate_mono_xml() {
    local OUT="$1"
    echo '    <family name="monospace">' > "$OUT"
    for W in $WEIGHTS; do
        echo "        <font weight=\"$W\" style=\"normal\">NotoSansMono-VF.ttf<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$OUT"
        echo "        <font weight=\"$W\" style=\"italic\">NotoSansMono-VF.ttf<axis tag=\"wght\" stylevalue=\"$W\" /><axis tag=\"slnt\" stylevalue=\"-10\" /></font>" >> "$OUT"
    done
    echo '    </family>' >> "$OUT"
}

# ==========================================
# 生成 serif (Noto Serif VF 100-900) XML
# ==========================================
generate_serif_xml() {
    local OUT="$1"
    echo '    <family name="serif">' > "$OUT"
    for W in 100 200 300 400 500 600 700 800 900; do
        echo "        <font weight=\"$W\" style=\"normal\">NotoSerif-VF.ttf<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$OUT"
        echo "        <font weight=\"$W\" style=\"italic\">NotoSerif-VF.ttf<axis tag=\"wght\" stylevalue=\"$W\" /><axis tag=\"ital\" stylevalue=\"1\" /></font>" >> "$OUT"
    done
    echo '    </family>' >> "$OUT"
}

# ==========================================
# 生成 CJK monospace XML (在 monospace family 中追加 CJK 条目)
#   使用与 CJK sans 相同的字体，但作为 monospace fallback
# ==========================================
generate_cjk_mono_xml() {
    local OUT="$1"
    local LANG_TAG="$2"
    local INDEX="$3"
    local LANG_PREFIX="${4:-jp}"
    echo "    <family $LANG_TAG>" > "$OUT"
    # weight 100-900: VF 原生
    for W in 100 200 300 400 500 600 700 800 900; do
        echo "        <font weight=\"$W\" style=\"normal\" index=\"$INDEX\" postScriptName=\"NotoSansCJK${LANG_PREFIX}-Thin\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$OUT"
    done
    # weight 1000: 静态 Black (每语言)
    echo "        <font weight=\"1000\" style=\"normal\" index=\"$INDEX\" postScriptName=\"NotoSansCJK${LANG_PREFIX}-Black\">NotoSansCJK${LANG_PREFIX}-Black.otf</font>" >> "$OUT"
    echo "    </family>" >> "$OUT"
}

# ==========================================
# 生成 CJK sans XML (符合 AOSP 可变字体规范)
#   weight 100-900: VF NotoSansCJK-VF.otf.ttc (axis 原生)
#   weight 1000: static per-language Black (NotoSansCJK{prefix}-Black.otf)
# ==========================================
generate_cjk_sans_xml() {
    local OUT="$1"
    local LANG_TAG="$2"
    local INDEX="$3"
    local LANG_PREFIX="${4:-jp}"
    echo "    <family $LANG_TAG>" > "$OUT"
    # weight 100-900: VF 原生
    for W in 100 200 300 400 500 600 700 800 900; do
        echo "        <font weight=\"$W\" style=\"normal\" index=\"$INDEX\" postScriptName=\"NotoSansCJK${LANG_PREFIX}-Thin\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$OUT"
    done
    # weight 1000: 静态 Black (每语言)
    echo "        <font weight=\"1000\" style=\"normal\" index=\"$INDEX\" postScriptName=\"NotoSansCJK${LANG_PREFIX}-Black\">NotoSansCJK${LANG_PREFIX}-Black.otf</font>" >> "$OUT"
    echo "    </family>" >> "$OUT"
}

# ==========================================
# 生成 CJK serif XML (符合 AOSP 可变字体规范)
#   weight 200-900: VF NotoSerifCJK-VF.otf.ttc (axis 原生)
#   weight 1000: static per-language Black (NotoSerifCJK{prefix}-Black.otf)
# ==========================================
generate_cjk_serif_xml() {
    local OUT="$1"
    local LANG_TAG="$2"
    local INDEX="$3"
    local LANG_PREFIX="${4:-jp}"
    echo "    <family $LANG_TAG>" > "$OUT"
    # weight 200-900: VF 原生
    for W in 200 300 400 500 600 700 800 900; do
        echo "        <font weight=\"$W\" style=\"normal\" index=\"$INDEX\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJK${LANG_PREFIX}-ExtraLight\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$OUT"
    done
    # weight 1000: 静态 Black (每语言)
    echo "        <font weight=\"1000\" style=\"normal\" index=\"$INDEX\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJK${LANG_PREFIX}-Black\">NotoSerifCJK${LANG_PREFIX}-Black.otf</font>" >> "$OUT"
    echo "    </family>" >> "$OUT"
}

FILES="fonts.xml fonts_base.xml"
FILEPATHS="/system/etc/ /system_ext/etc/ /product/etc/"

TMP_DIR="$MODPATH/tmp_payloads"
mkdir -p "$TMP_DIR"

for FILE in $FILES; do
  for FILEPATH in $FILEPATHS; do
    if [ -f "$FILEPATH$FILE" ]; then
      ui_print "- Patching $FILE ($FILEPATH)"
      case "$FILEPATH" in
        /system/*) SYSTEMFILEPATH=$FILEPATH ;;
        *) SYSTEMFILEPATH=/system$FILEPATH ;;
      esac

      if [ -n "$MIRRORPATH" ]; then
          SRC_XML="$MIRRORPATH$FILEPATH$FILE"
      else
          SRC_XML="$FILEPATH$FILE"
      fi

      mkdir -p "$MODPATH$SYSTEMFILEPATH"
      cp -af "$SRC_XML" "$MODPATH$SYSTEMFILEPATH$FILE"
      TARGET_XML="$MODPATH$SYSTEMFILEPATH$FILE"

      # 修复 serif 字重别名: 将 serif-bold(700) 扩展为完整字重别名链
      ui_print "  -> Expanding serif weight aliases..."
      sed -i 's/<alias name="serif-bold" to="serif" weight="700" \/>/<alias name="serif-thin" to="serif" weight="100" \/>\n<alias name="serif-light" to="serif" weight="300" \/>\n<alias name="serif-medium" to="serif" weight="400" \/>\n<alias name="serif-semi-bold" to="serif" weight="500" \/>\n<alias name="serif-bold" to="serif" weight="700" \/>\n<alias name="serif-black" to="serif" weight="900" \/>/g' "$TARGET_XML"

      # Google Sans Flex: 1-1000 (wght axis 1-1000)
      ui_print "  -> Replacing sans-serif with Google Sans Flex (wght 1-1000)..."
      generate_sans_serif_xml "$TMP_DIR/sans_serif.xml"
      replace_named_family "sans-serif" "$TMP_DIR/sans_serif.xml" "$TARGET_XML"

      # Noto Serif: 100-900 (wght axis)
      if [ -f "$MODPATH/system/fonts/NotoSerif-VF.ttf" ]; then
          ui_print "  -> Replacing serif with Noto Serif (wght 100-900)..."
          generate_serif_xml "$TMP_DIR/serif.xml"
          replace_named_family "serif" "$TMP_DIR/serif.xml" "$TARGET_XML"
      fi

      # Monospace: Noto Sans Mono 1-1000
      if [ -f "$MODPATH/system/fonts/NotoSansMono-VF.ttf" ]; then
          ui_print "  -> Replacing monospace with Noto Sans Mono (wght 1-1000)..."
          generate_mono_xml "$TMP_DIR/mono.xml"
          replace_named_family "monospace" "$TMP_DIR/mono.xml" "$TARGET_XML"
      fi

      # CJK: 1-1000 (VF clamp + static stubs hybrid)
      ui_print "  -> Fixing Noto CJK Weights 1-1000 & Android 16 PSNames..."
      for LANG_TAG in 'lang="ja"' 'lang="ko"' 'lang="zh-Hans"' 'lang="zh-Hant"' 'lang="zh-Bopo"' 'lang="zh-Hant zh-Bopo"' 'lang="zh-Hant,zh-Bopo"'; do

          INDEX="0"
          LANG_PREFIX="jp"
          case "$LANG_TAG" in
              *ko*) INDEX="1"; LANG_PREFIX="kr" ;;
              *zh-Hans*) INDEX="2"; LANG_PREFIX="sc" ;;
              *zh-Hant*|*zh-Bopo*) INDEX="3"; LANG_PREFIX="tc" ;;
          esac

          # 生成 CJK sans + serif + monospace 组合载荷
          generate_cjk_sans_xml "$TMP_DIR/cjk_sans.xml" "$LANG_TAG" "$INDEX" "$LANG_PREFIX"
          generate_cjk_serif_xml "$TMP_DIR/cjk_serif.xml" "$LANG_TAG" "$INDEX" "$LANG_PREFIX"
          generate_cjk_mono_xml "$TMP_DIR/cjk_mono.xml" "$LANG_TAG" "$INDEX" "$LANG_PREFIX"

          # 组合: sans family + serif family + mono family + static fallback family
          cat "$TMP_DIR/cjk_sans.xml" "$TMP_DIR/cjk_serif.xml" "$TMP_DIR/cjk_mono.xml" > "$TMP_DIR/cjk_payload.xml"
          cat << EOF >> "$TMP_DIR/cjk_payload.xml"
    <family $LANG_TAG>
        <font weight="400" style="normal" index="$INDEX" postScriptName="NotoSansCJKjp-Regular">NotoSansCJK-Regular.ttc</font>
        <font weight="400" style="normal" index="$INDEX" fallbackFor="serif" postScriptName="NotoSerifCJKjp-Regular">NotoSerifCJK-Regular.ttc</font>
    </family>
EOF
          replace_cjk_family "<family $LANG_TAG>" "$TMP_DIR/cjk_payload.xml" "$TARGET_XML"
      done

      # Hentaigana: 扩展为完整字重 1-1000
      ui_print "  -> Expanding Hentaigana weights..."
      echo '    <family lang="ja">' > "$TMP_DIR/hentaigana_payload.xml"
      for W in $WEIGHTS; do
          cat << ALICEOF >> "$TMP_DIR/hentaigana_payload.xml"
        <font weight="$W" style="normal" postScriptName="NotoSerifHentaigana-ExtraLight">
            NotoSerifHentaigana.ttf
            <axis tag="wght" stylevalue="$W" />
        </font>
ALICEOF
      done
      echo '    </family>' >> "$TMP_DIR/hentaigana_payload.xml"
      replace_family_by_keyword '<family lang="ja">' "NotoSerifHentaigana" "$TMP_DIR/hentaigana_payload.xml" "$TARGET_XML"
    fi
  done
done

# 处理 fonts_customization.xml (Google Pixel RRO 支持)
FILECUSTOM=fonts_customization.xml
FILECUSTOMPATH=/product/etc/
SYSTEMFILECUSTOMPATH=/system$FILECUSTOMPATH

if [ -f "$FILECUSTOMPATH$FILECUSTOM" ]; then
    if grep -q "google-sans" "$FILECUSTOMPATH$FILECUSTOM"; then
        ui_print "- Patching $FILECUSTOM (Google Pixel RRO)"

        if [ -n "$MIRRORPATH" ]; then
            SRC_CUST="$MIRRORPATH$FILECUSTOMPATH$FILECUSTOM"
        else
            SRC_CUST="$FILECUSTOMPATH$FILECUSTOM"
        fi

        mkdir -p "$MODPATH$SYSTEMFILECUSTOMPATH"
        cp -af "$SRC_CUST" "$MODPATH$SYSTEMFILECUSTOMPATH$FILECUSTOM"
        CUST_XML="$MODPATH$SYSTEMFILECUSTOMPATH$FILECUSTOM"

        sed -i '
/<family customizationType="new-named-family" name="google-sans-medium">/,/<\/family>/ {/<\/family>/! d;
/<\/family>/ s/.*/  <alias name="google-sans-medium" to="google-sans" weight="500" \/>/};
/<family customizationType="new-named-family" name="google-sans-bold">/,/<\/family>/ {/<\/family>/! d;
/<\/family>/ s/.*/  <alias name="google-sans-bold" to="google-sans" weight="700" \/>/};
/<family customizationType="new-named-family" name="google-sans-text-medium">/,/<\/family>/ {/<\/family>/! d;
/<\/family>/ s/.*/  <alias name="google-sans-text-medium" to="google-sans-text" weight="500" \/>/};
/<family customizationType="new-named-family" name="google-sans-text-bold">/,/<\/family>/ {/<\/family>/! d;
/<\/family>/ s/.*/  <alias name="google-sans-text-bold" to="google-sans-text" weight="700" \/>/};
/<family customizationType="new-named-family" name="google-sans-text-italic">/,/<\/family>/ {/<\/family>/! d;
/<\/family>/ s/.*/  <alias name="google-sans-text-italic" to="google-sans-text" weight="400" style="italic" \/>/};
/<family customizationType="new-named-family" name="google-sans-text-medium-italic">/,/<\/family>/ {/<\/family>/! d;
/<\/family>/ s/.*/  <alias name="google-sans-text-medium-italic" to="google-sans-text" weight="500" style="italic" \/>/};
/<family customizationType="new-named-family" name="google-sans-text-bold-italic">/,/<\/family>/ {/<\/family>/! d;
/<\/family>/ s/.*/  <alias name="google-sans-text-bold-italic" to="google-sans-text" weight="700" style="italic" \/>/};
' "$CUST_XML"
    fi
fi

# 清理临时文件
rm -rf "$TMP_DIR"

# 设置字体文件权限
ui_print "- Setting font permissions..."
set_perm_recursive "$MODPATH/system/fonts" 0 0 0755 0644

ui_print "- Latin & CJK Patching complete."

# Unicode Patching Logic
if [ -f "$MODPATH/lib/lib.sh" ]; then
    ui_print "- Applying Unicode Font Set Integration..."
    . "$MODPATH/lib/lib.sh"

    SHA1_DIR="$MODPATH/sha1"
    mkdir -p "$SHA1_DIR"

    FOUND_SYSTEM_XML=0
    for F in $FONT_XML_FILES; do
        for SUB in $FONT_XML_SUBDIRS; do
            SRC="$MODPATH/$SUB/$F"

            if [ -f "$SRC" ]; then
                FOUND_SYSTEM_XML=1
                ui_print "- Inserting Unicode fonts into $SRC"
                insert_fonts "$SRC"
            fi
        done
    done

    ui_print "- Unicode Integration complete."
fi

# 清理 patching 脚本和数据 (安装后不再需要, 保留 lib/awk.sh 供 action.sh 使用)
ui_print "- Cleaning up patching files..."
rm -rf "$MODPATH/config"
rm -rf "$MODPATH/font-source"
rm -rf "$MODPATH/lang"
find "$MODPATH/lib" -mindepth 1 -maxdepth 1 ! -name 'awk.sh' -exec rm -rf {} + 2>/dev/null

chmod 755 "$MODPATH/service.sh" 2>/dev/null

ui_print "*********************************"
ui_print " Installation Done "
ui_print "*********************************"
