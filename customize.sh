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
# 安全替换 XML 节点的通用函数 (替代危险的 sed)
# ==========================================
# 参数 1: 匹配的起始标签 (例如: <family lang="ja"> 或 <family name="sans-serif">)
# 参数 2: 包含要替换的全新 XML 内容的文件路径
# 参数 3: 目标 fonts.xml 路径
replace_xml_block() {
    local TARGET_TAG="$1"
    local PAYLOAD_FILE="$2"
    local TARGET_XML="$3"
    
    awk -v tag="$TARGET_TAG" -v payload="$(cat "$PAYLOAD_FILE")" '
    BEGIN { skip = 0 }
    # 找到目标标签，打印新内容并开启跳过模式
    index($0, tag) > 0 {
        print payload
        skip = 1
        next
    }
    # 找到闭合标签，关闭跳过模式
    index($0, "</family>") > 0 && skip {
        skip = 0
        next
    }
    # 非跳过模式下，原样输出
    !skip { print }
    ' "$TARGET_XML" > "${TARGET_XML}.tmp" && mv "${TARGET_XML}.tmp" "$TARGET_XML"
}

FILES="fonts.xml"
FILEPATHS="/system/etc/ /system_ext/etc/"

for FILE in $FILES; do
  for FILEPATH in $FILEPATHS; do
    if [ -f "$FILEPATH$FILE" ]; then
      ui_print "- Patching $FILE"
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
      TMP_DIR="$MODPATH/tmp_payloads"
      mkdir -p "$TMP_DIR"

      ui_print "  -> Fixing Google Sans Weights..."
      # 修复 1: 强制映射 Google Sans 静态字重，防止退化为 400/600
      cat << 'EOF' > "$TMP_DIR/sans_serif.xml"
    <family name="sans-serif">
        <font weight="100" style="normal">Roboto-Thin.ttf</font>
        <font weight="300" style="normal">Roboto-Light.ttf</font>
        <font weight="400" style="normal">Roboto-Regular.ttf</font>
        <font weight="500" style="normal">Roboto-Medium.ttf</font>
        <font weight="700" style="normal">Roboto-Bold.ttf</font>
        <font weight="900" style="normal">Roboto-Black.ttf</font>
    </family>
EOF
      replace_xml_block '<family name="sans-serif">' "$TMP_DIR/sans_serif.xml" "$TARGET_XML"

      ui_print "  -> Fixing Noto CJK Weights & Android 16 PSNames..."
      # 修复 2: 使用 Android 16 允许的真实 postScriptName (Thin/Light/Regular/Medium/Bold/Black)
      # 移除所有 ExtraLight, SemiBold, ExtraBold，将它们安全映射至相邻的有效字重
      for LANG_TAG in 'lang="ja"' 'lang="ko"' 'lang="zh-Hans"' 'lang="zh-Hant"' 'lang="zh-Bopo"' 'lang="zh-Hant zh-Bopo"' 'lang="zh-Hant,zh-Bopo"'; do
          
          # 提取 index 值 (根据语言)
          INDEX="0"
          case "$LANG_TAG" in
              *ko*) INDEX="1" ;;
              *zh-Hans*) INDEX="2" ;;
              *zh-Hant*|*zh-Bopo*) INDEX="3" ;;
          esac

          cat << EOF > "$TMP_DIR/cjk_payload.xml"
    <family $LANG_TAG>
        <font weight="100" style="normal" index="$INDEX" postScriptName="NotoSansCJKjp-Thin">NotoSansCJK-VF.otf.ttc<axis tag="wght" stylevalue="100" /></font>
        <font weight="200" style="normal" index="$INDEX" postScriptName="NotoSansCJKjp-Thin">NotoSansCJK-VF.otf.ttc<axis tag="wght" stylevalue="200" /></font>
        <font weight="300" style="normal" index="$INDEX" postScriptName="NotoSansCJKjp-Light">NotoSansCJK-VF.otf.ttc<axis tag="wght" stylevalue="300" /></font>
        <font weight="400" style="normal" index="$INDEX" postScriptName="NotoSansCJKjp-Regular">NotoSansCJK-VF.otf.ttc<axis tag="wght" stylevalue="400" /></font>
        <font weight="500" style="normal" index="$INDEX" postScriptName="NotoSansCJKjp-Medium">NotoSansCJK-VF.otf.ttc<axis tag="wght" stylevalue="500" /></font>
        <font weight="600" style="normal" index="$INDEX" postScriptName="NotoSansCJKjp-Bold">NotoSansCJK-VF.otf.ttc<axis tag="wght" stylevalue="600" /></font>
        <font weight="700" style="normal" index="$INDEX" postScriptName="NotoSansCJKjp-Bold">NotoSansCJK-VF.otf.ttc<axis tag="wght" stylevalue="700" /></font>
        <font weight="800" style="normal" index="$INDEX" postScriptName="NotoSansCJKjp-Black">NotoSansCJK-VF.otf.ttc<axis tag="wght" stylevalue="800" /></font>
        <font weight="900" style="normal" index="$INDEX" postScriptName="NotoSansCJKjp-Black">NotoSansCJK-VF.otf.ttc<axis tag="wght" stylevalue="900" /></font>
        <font weight="200" style="normal" index="$INDEX" fallbackFor="serif" postScriptName="NotoSerifCJKjp-Thin">NotoSerifCJK-VF.otf.ttc<axis tag="wght" stylevalue="200" /></font>
        <font weight="300" style="normal" index="$INDEX" fallbackFor="serif" postScriptName="NotoSerifCJKjp-Light">NotoSerifCJK-VF.otf.ttc<axis tag="wght" stylevalue="300" /></font>
        <font weight="400" style="normal" index="$INDEX" fallbackFor="serif" postScriptName="NotoSerifCJKjp-Regular">NotoSerifCJK-VF.otf.ttc<axis tag="wght" stylevalue="400" /></font>
        <font weight="500" style="normal" index="$INDEX" fallbackFor="serif" postScriptName="NotoSerifCJKjp-Medium">NotoSerifCJK-VF.otf.ttc<axis tag="wght" stylevalue="500" /></font>
        <font weight="600" style="normal" index="$INDEX" fallbackFor="serif" postScriptName="NotoSerifCJKjp-Bold">NotoSerifCJK-VF.otf.ttc<axis tag="wght" stylevalue="600" /></font>
        <font weight="700" style="normal" index="$INDEX" fallbackFor="serif" postScriptName="NotoSerifCJKjp-Bold">NotoSerifCJK-VF.otf.ttc<axis tag="wght" stylevalue="700" /></font>
        <font weight="800" style="normal" index="$INDEX" fallbackFor="serif" postScriptName="NotoSerifCJKjp-Black">NotoSerifCJK-VF.otf.ttc<axis tag="wght" stylevalue="800" /></font>
        <font weight="900" style="normal" index="$INDEX" fallbackFor="serif" postScriptName="NotoSerifCJKjp-Black">NotoSerifCJK-VF.otf.ttc<axis tag="wght" stylevalue="900" /></font>
    </family>
    <family $LANG_TAG>
        <font weight="400" style="normal" index="$INDEX" postScriptName="NotoSansCJKjp-Regular">NotoSansCJK-Regular.ttc</font>
        <font weight="400" style="normal" index="$INDEX" fallbackFor="serif" postScriptName="NotoSerifCJKjp-Regular">NotoSerifCJK-Regular.ttc</font>
    </family>
EOF
          # 使用我们安全的 awk 函数进行定点替换 (修复 Unicode 吞噬 BUG)
          replace_xml_block "<family $LANG_TAG>" "$TMP_DIR/cjk_payload.xml" "$TARGET_XML"
      done
      
      # 清理临时文件
      rm -rf "$TMP_DIR"
    fi
  done
done

ui_print "- Latin & CJK Patching complete."

# Unicode Patching Logic 维持原样，现在系统底层 fallback 字体终于安全存活了！
if [ -f "$MODPATH/lib/lib.sh" ]; then
    ui_print "- Applying Unicode Font Set Integration..."
    . "$MODPATH/lib/lib.sh"

    SHA1_DIR="$MODPATH/sha1"
    mkdir -p "$SHA1_DIR"

    FOUND_SYSTEM_XML=0
    FONT_XML_FILES="fonts.xml"
    FONT_XML_SUBDIRS="etc system_ext/etc"

    for F in $FONT_XML_FILES; do
        for SUB in $FONT_XML_SUBDIRS; do
            P="/$SUB/"
            SRC="$MODPATH/system/$SUB/$F"
            
            if [ -f "$SRC" ]; then
                FOUND_SYSTEM_XML=1
                ui_print "- Inserting Unicode fonts into $SRC"
                insert_fonts "$SRC"
            fi
        done
    done

    ui_print "- Unicode Integration complete."
fi

chmod 755 "$MODPATH/service.sh" 2>/dev/null

ui_print "*********************************"
ui_print " Installation Done "
ui_print "*********************************"