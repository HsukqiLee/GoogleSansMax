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

# We use Magic Mount for system/fonts, but we need to patch fonts.xml dynamically
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

      # Patch Noto Sans CJK with unique postScriptNames to fix Android 16/17 weight 100/200 bug
      sed -i '
/<family lang=\"ja\">/,/<\/family>/ {:a;N;/<\/family>/!ba;
s/<family lang=\"ja\">.*Noto.*CJK.*<\/family>/<family lang=\"ja\">
<font weight=\"100\" style=\"normal\" index=\"0\" postScriptName=\"NotoSansCJKjp-Thin\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"100\" \/><\/font>
<font weight=\"200\" style=\"normal\" index=\"0\" postScriptName=\"NotoSansCJKjp-ExtraLight\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"200\" \/><\/font>
<font weight=\"300\" style=\"normal\" index=\"0\" postScriptName=\"NotoSansCJKjp-Light\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"300\" \/><\/font>
<font weight=\"400\" style=\"normal\" index=\"0\" postScriptName=\"NotoSansCJKjp-Regular\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"400\" \/><\/font>
<font weight=\"500\" style=\"normal\" index=\"0\" postScriptName=\"NotoSansCJKjp-Medium\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"500\" \/><\/font>
<font weight=\"600\" style=\"normal\" index=\"0\" postScriptName=\"NotoSansCJKjp-SemiBold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"600\" \/><\/font>
<font weight=\"700\" style=\"normal\" index=\"0\" postScriptName=\"NotoSansCJKjp-Bold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"700\" \/><\/font>
<font weight=\"800\" style=\"normal\" index=\"0\" postScriptName=\"NotoSansCJKjp-ExtraBold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"800\" \/><\/font>
<font weight=\"900\" style=\"normal\" index=\"0\" postScriptName=\"NotoSansCJKjp-Black\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"900\" \/><\/font>
<font weight=\"200\" style=\"normal\" index=\"0\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-ExtraLight\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"200\" \/><\/font>
<font weight=\"300\" style=\"normal\" index=\"0\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Light\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"300\" \/><\/font>
<font weight=\"400\" style=\"normal\" index=\"0\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Regular\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"400\" \/><\/font>
<font weight=\"500\" style=\"normal\" index=\"0\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Medium\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"500\" \/><\/font>
<font weight=\"600\" style=\"normal\" index=\"0\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-SemiBold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"600\" \/><\/font>
<font weight=\"700\" style=\"normal\" index=\"0\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Bold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"700\" \/><\/font>
<font weight=\"800\" style=\"normal\" index=\"0\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-ExtraBold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"800\" \/><\/font>
<font weight=\"900\" style=\"normal\" index=\"0\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Black\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"900\" \/><\/font>
<\/family>
<family lang=\"ja\">
<font weight=\"400\" style=\"normal\" index=\"0\" postScriptName=\"NotoSansCJKjp-Regular\">NotoSansCJK-Regular.ttc<\/font>
<font weight=\"400\" style=\"normal\" index=\"0\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Regular\">NotoSerifCJK-Regular.ttc<\/font>
<\/family>/};
' "$TARGET_XML"
      sed -i '
/<family lang=\"ko\">/,/<\/family>/ {:a;N;/<\/family>/!ba;
s/<family lang=\"ko\">.*Noto.*CJK.*<\/family>/<family lang=\"ko\">
<font weight=\"100\" style=\"normal\" index=\"1\" postScriptName=\"NotoSansCJKjp-Thin\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"100\" \/><\/font>
<font weight=\"200\" style=\"normal\" index=\"1\" postScriptName=\"NotoSansCJKjp-ExtraLight\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"200\" \/><\/font>
<font weight=\"300\" style=\"normal\" index=\"1\" postScriptName=\"NotoSansCJKjp-Light\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"300\" \/><\/font>
<font weight=\"400\" style=\"normal\" index=\"1\" postScriptName=\"NotoSansCJKjp-Regular\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"400\" \/><\/font>
<font weight=\"500\" style=\"normal\" index=\"1\" postScriptName=\"NotoSansCJKjp-Medium\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"500\" \/><\/font>
<font weight=\"600\" style=\"normal\" index=\"1\" postScriptName=\"NotoSansCJKjp-SemiBold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"600\" \/><\/font>
<font weight=\"700\" style=\"normal\" index=\"1\" postScriptName=\"NotoSansCJKjp-Bold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"700\" \/><\/font>
<font weight=\"800\" style=\"normal\" index=\"1\" postScriptName=\"NotoSansCJKjp-ExtraBold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"800\" \/><\/font>
<font weight=\"900\" style=\"normal\" index=\"1\" postScriptName=\"NotoSansCJKjp-Black\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"900\" \/><\/font>
<font weight=\"200\" style=\"normal\" index=\"1\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-ExtraLight\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"200\" \/><\/font>
<font weight=\"300\" style=\"normal\" index=\"1\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Light\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"300\" \/><\/font>
<font weight=\"400\" style=\"normal\" index=\"1\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Regular\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"400\" \/><\/font>
<font weight=\"500\" style=\"normal\" index=\"1\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Medium\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"500\" \/><\/font>
<font weight=\"600\" style=\"normal\" index=\"1\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-SemiBold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"600\" \/><\/font>
<font weight=\"700\" style=\"normal\" index=\"1\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Bold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"700\" \/><\/font>
<font weight=\"800\" style=\"normal\" index=\"1\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-ExtraBold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"800\" \/><\/font>
<font weight=\"900\" style=\"normal\" index=\"1\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Black\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"900\" \/><\/font>
<\/family>
<family lang=\"ko\">
<font weight=\"400\" style=\"normal\" index=\"1\" postScriptName=\"NotoSansCJKjp-Regular\">NotoSansCJK-Regular.ttc<\/font>
<font weight=\"400\" style=\"normal\" index=\"1\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Regular\">NotoSerifCJK-Regular.ttc<\/font>
<\/family>/};
' "$TARGET_XML"
      sed -i '
/<family lang=\"zh-Hans\">/,/<\/family>/ {:a;N;/<\/family>/!ba;
s/<family lang=\"zh-Hans\">.*Noto.*CJK.*<\/family>/<family lang=\"zh-Hans\">
<font weight=\"100\" style=\"normal\" index=\"2\" postScriptName=\"NotoSansCJKjp-Thin\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"100\" \/><\/font>
<font weight=\"200\" style=\"normal\" index=\"2\" postScriptName=\"NotoSansCJKjp-ExtraLight\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"200\" \/><\/font>
<font weight=\"300\" style=\"normal\" index=\"2\" postScriptName=\"NotoSansCJKjp-Light\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"300\" \/><\/font>
<font weight=\"400\" style=\"normal\" index=\"2\" postScriptName=\"NotoSansCJKjp-Regular\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"400\" \/><\/font>
<font weight=\"500\" style=\"normal\" index=\"2\" postScriptName=\"NotoSansCJKjp-Medium\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"500\" \/><\/font>
<font weight=\"600\" style=\"normal\" index=\"2\" postScriptName=\"NotoSansCJKjp-SemiBold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"600\" \/><\/font>
<font weight=\"700\" style=\"normal\" index=\"2\" postScriptName=\"NotoSansCJKjp-Bold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"700\" \/><\/font>
<font weight=\"800\" style=\"normal\" index=\"2\" postScriptName=\"NotoSansCJKjp-ExtraBold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"800\" \/><\/font>
<font weight=\"900\" style=\"normal\" index=\"2\" postScriptName=\"NotoSansCJKjp-Black\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"900\" \/><\/font>
<font weight=\"200\" style=\"normal\" index=\"2\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-ExtraLight\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"200\" \/><\/font>
<font weight=\"300\" style=\"normal\" index=\"2\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Light\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"300\" \/><\/font>
<font weight=\"400\" style=\"normal\" index=\"2\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Regular\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"400\" \/><\/font>
<font weight=\"500\" style=\"normal\" index=\"2\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Medium\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"500\" \/><\/font>
<font weight=\"600\" style=\"normal\" index=\"2\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-SemiBold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"600\" \/><\/font>
<font weight=\"700\" style=\"normal\" index=\"2\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Bold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"700\" \/><\/font>
<font weight=\"800\" style=\"normal\" index=\"2\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-ExtraBold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"800\" \/><\/font>
<font weight=\"900\" style=\"normal\" index=\"2\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Black\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"900\" \/><\/font>
<\/family>
<family lang=\"zh-Hans\">
<font weight=\"400\" style=\"normal\" index=\"2\" postScriptName=\"NotoSansCJKjp-Regular\">NotoSansCJK-Regular.ttc<\/font>
<font weight=\"400\" style=\"normal\" index=\"2\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Regular\">NotoSerifCJK-Regular.ttc<\/font>
<\/family>/};
' "$TARGET_XML"
      sed -i '
/<family lang=\"zh-Hant\">/,/<\/family>/ {:a;N;/<\/family>/!ba;
s/<family lang=\"zh-Hant\">.*Noto.*CJK.*<\/family>/<family lang=\"zh-Hant\">
<font weight=\"100\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Thin\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"100\" \/><\/font>
<font weight=\"200\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-ExtraLight\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"200\" \/><\/font>
<font weight=\"300\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Light\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"300\" \/><\/font>
<font weight=\"400\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Regular\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"400\" \/><\/font>
<font weight=\"500\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Medium\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"500\" \/><\/font>
<font weight=\"600\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-SemiBold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"600\" \/><\/font>
<font weight=\"700\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Bold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"700\" \/><\/font>
<font weight=\"800\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-ExtraBold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"800\" \/><\/font>
<font weight=\"900\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Black\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"900\" \/><\/font>
<font weight=\"200\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-ExtraLight\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"200\" \/><\/font>
<font weight=\"300\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Light\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"300\" \/><\/font>
<font weight=\"400\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Regular\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"400\" \/><\/font>
<font weight=\"500\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Medium\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"500\" \/><\/font>
<font weight=\"600\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-SemiBold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"600\" \/><\/font>
<font weight=\"700\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Bold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"700\" \/><\/font>
<font weight=\"800\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-ExtraBold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"800\" \/><\/font>
<font weight=\"900\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Black\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"900\" \/><\/font>
<\/family>
<family lang=\"zh-Hant\">
<font weight=\"400\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Regular\">NotoSansCJK-Regular.ttc<\/font>
<font weight=\"400\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Regular\">NotoSerifCJK-Regular.ttc<\/font>
<\/family>/};
' "$TARGET_XML"
      sed -i '
/<family lang=\"zh-Bopo\">/,/<\/family>/ {:a;N;/<\/family>/!ba;
s/<family lang=\"zh-Bopo\">.*Noto.*CJK.*<\/family>/<family lang=\"zh-Bopo\">
<font weight=\"100\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Thin\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"100\" \/><\/font>
<font weight=\"200\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-ExtraLight\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"200\" \/><\/font>
<font weight=\"300\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Light\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"300\" \/><\/font>
<font weight=\"400\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Regular\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"400\" \/><\/font>
<font weight=\"500\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Medium\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"500\" \/><\/font>
<font weight=\"600\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-SemiBold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"600\" \/><\/font>
<font weight=\"700\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Bold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"700\" \/><\/font>
<font weight=\"800\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-ExtraBold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"800\" \/><\/font>
<font weight=\"900\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Black\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"900\" \/><\/font>
<font weight=\"200\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-ExtraLight\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"200\" \/><\/font>
<font weight=\"300\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Light\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"300\" \/><\/font>
<font weight=\"400\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Regular\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"400\" \/><\/font>
<font weight=\"500\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Medium\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"500\" \/><\/font>
<font weight=\"600\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-SemiBold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"600\" \/><\/font>
<font weight=\"700\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Bold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"700\" \/><\/font>
<font weight=\"800\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-ExtraBold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"800\" \/><\/font>
<font weight=\"900\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Black\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"900\" \/><\/font>
<\/family>
<family lang=\"zh-Bopo\">
<font weight=\"400\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Regular\">NotoSansCJK-Regular.ttc<\/font>
<font weight=\"400\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Regular\">NotoSerifCJK-Regular.ttc<\/font>
<\/family>/};
' "$TARGET_XML"
      sed -i '
/<family lang=\"zh-Hant zh-Bopo\">/,/<\/family>/ {:a;N;/<\/family>/!ba;
s/<family lang=\"zh-Hant zh-Bopo\">.*Noto.*CJK.*<\/family>/<family lang=\"zh-Hant zh-Bopo\">
<font weight=\"100\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Thin\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"100\" \/><\/font>
<font weight=\"200\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-ExtraLight\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"200\" \/><\/font>
<font weight=\"300\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Light\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"300\" \/><\/font>
<font weight=\"400\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Regular\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"400\" \/><\/font>
<font weight=\"500\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Medium\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"500\" \/><\/font>
<font weight=\"600\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-SemiBold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"600\" \/><\/font>
<font weight=\"700\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Bold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"700\" \/><\/font>
<font weight=\"800\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-ExtraBold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"800\" \/><\/font>
<font weight=\"900\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Black\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"900\" \/><\/font>
<font weight=\"200\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-ExtraLight\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"200\" \/><\/font>
<font weight=\"300\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Light\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"300\" \/><\/font>
<font weight=\"400\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Regular\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"400\" \/><\/font>
<font weight=\"500\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Medium\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"500\" \/><\/font>
<font weight=\"600\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-SemiBold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"600\" \/><\/font>
<font weight=\"700\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Bold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"700\" \/><\/font>
<font weight=\"800\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-ExtraBold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"800\" \/><\/font>
<font weight=\"900\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Black\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"900\" \/><\/font>
<\/family>
<family lang=\"zh-Hant zh-Bopo\">
<font weight=\"400\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Regular\">NotoSansCJK-Regular.ttc<\/font>
<font weight=\"400\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Regular\">NotoSerifCJK-Regular.ttc<\/font>
<\/family>/};
' "$TARGET_XML"
      sed -i '
/<family lang=\"zh-Hant,zh-Bopo\">/,/<\/family>/ {:a;N;/<\/family>/!ba;
s/<family lang=\"zh-Hant,zh-Bopo\">.*Noto.*CJK.*<\/family>/<family lang=\"zh-Hant,zh-Bopo\">
<font weight=\"100\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Thin\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"100\" \/><\/font>
<font weight=\"200\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-ExtraLight\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"200\" \/><\/font>
<font weight=\"300\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Light\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"300\" \/><\/font>
<font weight=\"400\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Regular\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"400\" \/><\/font>
<font weight=\"500\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Medium\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"500\" \/><\/font>
<font weight=\"600\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-SemiBold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"600\" \/><\/font>
<font weight=\"700\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Bold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"700\" \/><\/font>
<font weight=\"800\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-ExtraBold\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"800\" \/><\/font>
<font weight=\"900\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Black\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"900\" \/><\/font>
<font weight=\"200\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-ExtraLight\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"200\" \/><\/font>
<font weight=\"300\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Light\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"300\" \/><\/font>
<font weight=\"400\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Regular\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"400\" \/><\/font>
<font weight=\"500\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Medium\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"500\" \/><\/font>
<font weight=\"600\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-SemiBold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"600\" \/><\/font>
<font weight=\"700\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Bold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"700\" \/><\/font>
<font weight=\"800\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-ExtraBold\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"800\" \/><\/font>
<font weight=\"900\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Black\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"900\" \/><\/font>
<\/family>
<family lang=\"zh-Hant,zh-Bopo\">
<font weight=\"400\" style=\"normal\" index=\"3\" postScriptName=\"NotoSansCJKjp-Regular\">NotoSansCJK-Regular.ttc<\/font>
<font weight=\"400\" style=\"normal\" index=\"3\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJKjp-Regular\">NotoSerifCJK-Regular.ttc<\/font>
<\/family>/};
' "$TARGET_XML"

    fi
  done
done

ui_print "- Latin & CJK Patching complete."

# Unicode Patching Logic
if [ -f "$MODPATH/lib/lib.sh" ]; then
    ui_print "- Applying Unicode Font Set Integration..."
    . "$MODPATH/lib/lib.sh"

    SHA1_DIR="$MODPATH/sha1"
    mkdir -p "$SHA1_DIR"

    FOUND_SYSTEM_XML=0
    FONT_XML_FILES="fonts.xml"
    FONT_XML_SUBDIRS="etc"

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

ui_print "*********************************"
ui_print " Installation Done "
ui_print "*********************************"
