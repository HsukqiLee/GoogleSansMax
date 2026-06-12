#!/system/bin/sh
# ==========================================
# GoogleSansMax 热更新 (Magisk/KernelSU Action)
#   用法:
#     action.sh           增量更新字体文件
#     action.sh --repatch 重新 patch XML (OTA 后或系统字体变化时)
# ==========================================

MODDIR="${0%/*}"
LIBDIR="$MODDIR/lib"
TMPDIR="/data/local/tmp/gsm_update"
REMOTE_BASE="https://raw.githubusercontent.com/HsukqiLee/GoogleSansMax/main"

# ==========================================
# 字体增量更新
# ==========================================
update_fonts() {
    ui_print() { echo "$1"; }

    ui_print "====================================="
    ui_print "  GoogleSansMax Font Updater"
    ui_print "====================================="
    ui_print ""

    # 检查 manifest
    if [ ! -f "$LIBDIR/manifest.txt" ]; then
        ui_print "[!] Local manifest not found"
        ui_print "    Please re-flash the module to enable hot updates"
        return 1
    fi

    # 下载远程 manifest
    mkdir -p "$TMPDIR"
    ui_print "[1/4] Checking for updates..."
    REMOTE_MANIFEST="$TMPDIR/manifest.txt"
    curl -L --retry 3 -s "$REMOTE_BASE/manifest.txt" -o "$REMOTE_MANIFEST" 2>/dev/null

    if [ ! -s "$REMOTE_MANIFEST" ]; then
        ui_print "    Failed to check updates (network error)"
        rm -rf "$TMPDIR"
        return 1
    fi

    # 比较 manifest，找出需要更新的文件
    LOCAL_MANIFEST="$LIBDIR/manifest.txt"
    CHANGED=""
    TOTAL_SIZE=0
    COUNT=0

    while IFS='|' read -r REMOTE_FILE REMOTE_HASH REMOTE_SIZE; do
        [ -z "$REMOTE_FILE" ] && continue
        [[ "$REMOTE_FILE" == \#* ]] && continue

        LOCAL_ENTRY=$(grep "^${REMOTE_FILE}|" "$LOCAL_MANIFEST" 2>/dev/null)
        LOCAL_HASH=$(echo "$LOCAL_ENTRY" | cut -d'|' -f2)

        if [ "$REMOTE_HASH" != "$LOCAL_HASH" ]; then
            CHANGED="$CHANGED $REMOTE_FILE"
            TOTAL_SIZE=$((TOTAL_SIZE + REMOTE_SIZE))
            COUNT=$((COUNT + 1))
        fi
    done < "$REMOTE_MANIFEST"

    if [ $COUNT -eq 0 ]; then
        ui_print "    All fonts are up to date!"
        rm -rf "$TMPDIR"
        return 0
    fi

    SIZE_MB=$((TOTAL_SIZE / 1048576))
    ui_print "    Found $COUNT font(s) to update (~${SIZE_MB}MB)"
    ui_print ""

    # 下载变更的文件
    ui_print "[2/4] Downloading updated files..."
    SUCCESS=0
    FAIL=0

    for FILE in $CHANGED; do
        ui_print "    Downloading $FILE..."

        # 根据文件类型决定下载目标
        case "$FILE" in
            system/fonts/*)
                DEST_DIR="$MODDIR/$(dirname "$FILE")"
                ;;
            lib/*)
                DEST_DIR="$MODDIR/$(dirname "$FILE")"
                ;;
            *.sh)
                DEST_DIR="$MODDIR"
                ;;
            module.prop)
                # 跳过 module.prop, 由 versionCode bump 处理
                continue
                ;;
            *)
                DEST_DIR="$MODDIR/$(dirname "$FILE")"
                ;;
        esac

        mkdir -p "$DEST_DIR"
        curl -L --retry 3 -s "$REMOTE_BASE/$FILE" -o "$DEST_DIR/$(basename "$FILE").tmp" 2>/dev/null
        if [ $? -eq 0 ] && [ -s "$DEST_DIR/$(basename "$FILE").tmp" ]; then
            mv "$DEST_DIR/$(basename "$FILE").tmp" "$DEST_DIR/$(basename "$FILE")"
            chmod 755 "$DEST_DIR/$(basename "$FILE")" 2>/dev/null
            SUCCESS=$((SUCCESS + 1))
        else
            rm -f "$DEST_DIR/$(basename "$FILE").tmp"
            ui_print "    WARNING: Failed to download $FILE"
            FAIL=$((FAIL + 1))
        fi
    done

    ui_print "    Downloaded: $SUCCESS, Failed: $FAIL"
    ui_print ""

    if [ $SUCCESS -eq 0 ]; then
        ui_print "[!] No files were updated"
        rm -rf "$TMPDIR"
        return 1
    fi

    # 更新 manifest
    ui_print "[3/4] Updating manifest..."
    cp "$REMOTE_MANIFEST" "$LOCAL_MANIFEST"

    # 更新 module.prop versionCode
    if [ -f "$MODDIR/module.prop" ]; then
        OLD_CODE=$(grep '^versionCode=' "$MODDIR/module.prop" | cut -d'=' -f2)
        NEW_CODE=$((OLD_CODE + 1))
        sed -i "s/^versionCode=.*/versionCode=$NEW_CODE/" "$MODDIR/module.prop"
    fi

    # 清理
    rm -rf "$TMPDIR"

    ui_print "[4/4] Done!"
    ui_print ""
    ui_print "Updated $SUCCESS file(s). Reboot to apply."
    ui_print ""
    return 0
}

# ==========================================
# XML 重新 Patch (OTA 后使用)
# ==========================================
repatch_xml() {
    ui_print() { echo "$1"; }

    ui_print "====================================="
    ui_print "  GoogleSansMax XML Re-Patcher"
    ui_print "====================================="
    ui_print ""

    # 加载共享函数
    if [ ! -f "$LIBDIR/awk.sh" ]; then
        ui_print "[!] lib/awk.sh not found"
        return 1
    fi
    . "$LIBDIR/awk.sh"

    WEIGHTS="100 200 300 400 500 600 700 800 900 1000"
    PAYLOADS="$MODDIR/tmp_payloads"
    mkdir -p "$PAYLOADS"

    # 处理所有被 patch 的 XML 文件
    ORIG_DIR="$MODDIR/lib/orig"
    PATCHED_FILES="fonts.xml fonts_base.xml font_fallback.xml"
    for FILE in $PATCHED_FILES; do
        for FILEPATH in /system/etc/ /system_ext/etc/ /product/etc/; do
            if [ -f "$FILEPATH$FILE" ]; then
                case "$FILEPATH" in
                    /system/*) SYS_PATH=$FILEPATH ;;
                    *) SYS_PATH=/system$FILEPATH ;;
                esac

                TARGET="$MODDIR${SYS_PATH}$FILE"

                # 总是从备份复制原始文件作为基底 (不复用已 patch 的版本)
                ORIG_SUB="${SYS_PATH#system/}"
                ORIG_SRC="$ORIG_DIR/${ORIG_SUB}${FILE}"
                mkdir -p "$MODDIR$SYS_PATH" "$ORIG_DIR/$ORIG_SUB"
                if [ -f "$ORIG_SRC" ]; then
                    cp -af "$ORIG_SRC" "$TARGET"
                else
                    # 首次 repatch 没有备份时, 从系统路径读取并保存备份
                    cp -af "$FILEPATH$FILE" "$TARGET"
                    cp -af "$TARGET" "$ORIG_SRC"
                fi

                ui_print "- Re-patching $FILE..."

                if [ "$FILE" = "font_fallback.xml" ]; then
                    # font_fallback.xml: Android 15+ 新 schema
                    #   显式 weight bucket + <axis> (与 awk.sh patch_font_fallback 一致)
                    patch_font_fallback "$TARGET" "$PAYLOADS"
                    # Fix SELinux context (repatch may reset it)
                    FB_CTX="u:object_r:system_font_fallback_file:s0"
                    chcon "$FB_CTX" "$TARGET" 2>/dev/null \
                        || setfattr -n security.selinux -v "$FB_CTX" "$TARGET" 2>/dev/null \
                        || ui_print "  ! Could not set context on $TARGET"
                else
                    # fonts.xml / fonts_base.xml: 旧 schema
                    # Serif weight aliases
                    sed -i 's/<alias name="serif-bold" to="serif" weight="700" \/>/<alias name="serif-thin" to="serif" weight="100" \/>\n<alias name="serif-light" to="serif" weight="300" \/>\n<alias name="serif-medium" to="serif" weight="400" \/>\n<alias name="serif-semi-bold" to="serif" weight="500" \/>\n<alias name="serif-bold" to="serif" weight="700" \/>\n<alias name="serif-black" to="serif" weight="900" \/>/g' "$TARGET"

                    # sans-serif
                    echo '    <family name="sans-serif">' > "$PAYLOADS/sans_serif.xml"
                    for W in $WEIGHTS; do
                        echo "        <font weight=\"$W\" style=\"normal\">GoogleSansFlex-Regular.ttf<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$PAYLOADS/sans_serif.xml"
                        echo "        <font weight=\"$W\" style=\"italic\">GoogleSansFlex-Regular.ttf<axis tag=\"wght\" stylevalue=\"$W\" /><axis tag=\"slnt\" stylevalue=\"-10\" /></font>" >> "$PAYLOADS/sans_serif.xml"
                    done
                    echo '    </family>' >> "$PAYLOADS/sans_serif.xml"
                    replace_named_family "sans-serif" "$PAYLOADS/sans_serif.xml" "$TARGET"

                    # serif
                    echo '    <family name="serif">' > "$PAYLOADS/serif.xml"
                    for W in 100 200 300 400 500 600 700 800 900; do
                        echo "        <font weight=\"$W\" style=\"normal\">NotoSerif-VF.ttf<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$PAYLOADS/serif.xml"
                        echo "        <font weight=\"$W\" style=\"italic\">NotoSerif-Italic-VF.ttf<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$PAYLOADS/serif.xml"
                    done
                    echo '    </family>' >> "$PAYLOADS/serif.xml"
                    replace_named_family "serif" "$PAYLOADS/serif.xml" "$TARGET"

                    # monospace
                    echo '    <family name="monospace">' > "$PAYLOADS/mono.xml"
                    for W in $WEIGHTS; do
                        echo "        <font weight=\"$W\" style=\"normal\">NotoSansMono-VF.ttf<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$PAYLOADS/mono.xml"
                        echo "        <font weight=\"$W\" style=\"italic\">NotoSansMono-VF.ttf<axis tag=\"wght\" stylevalue=\"$W\" /><axis tag=\"slnt\" stylevalue=\"-10\" /></font>" >> "$PAYLOADS/mono.xml"
                    done
                    echo '    </family>' >> "$PAYLOADS/mono.xml"
                    replace_named_family "monospace" "$PAYLOADS/mono.xml" "$TARGET"

                    # CJK families
                    for LANG_TAG in 'lang="ja"' 'lang="ko"' 'lang="zh-Hans"' 'lang="zh-Hant,zh-Bopo"'; do
                        INDEX="0"
                        LANG_PREFIX="jp"
                        case "$LANG_TAG" in
                            *ko*) INDEX="1"; LANG_PREFIX="kr" ;;
                            *zh-Hans*) INDEX="2"; LANG_PREFIX="sc" ;;
                            *zh-Hant*) INDEX="3"; LANG_PREFIX="tc" ;;
                        esac

                        # CJK sans
                        echo "    <family $LANG_TAG>" > "$PAYLOADS/cjk_sans.xml"
                        for W in 100 200 300 400 500 600 700 800 900; do
                            echo "        <font weight=\"$W\" style=\"normal\" index=\"$INDEX\" postScriptName=\"NotoSansCJK${LANG_PREFIX}-Thin\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$PAYLOADS/cjk_sans.xml"
                        done
                        echo "        <font weight=\"1000\" style=\"normal\" index=\"$INDEX\" postScriptName=\"NotoSansCJK${LANG_PREFIX}-Black\">NotoSansCJK${LANG_PREFIX}-Black.otf</font>" >> "$PAYLOADS/cjk_sans.xml"
                        echo "    </family>" >> "$PAYLOADS/cjk_sans.xml"

                        # CJK serif
                        echo "    <family $LANG_TAG>" > "$PAYLOADS/cjk_serif.xml"
                        for W in 200 300 400 500 600 700 800 900; do
                            echo "        <font weight=\"$W\" style=\"normal\" index=\"$INDEX\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJK${LANG_PREFIX}-ExtraLight\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$PAYLOADS/cjk_serif.xml"
                        done
                        echo "        <font weight=\"1000\" style=\"normal\" index=\"$INDEX\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJK${LANG_PREFIX}-Black\">NotoSerifCJK${LANG_PREFIX}-Black.otf</font>" >> "$PAYLOADS/cjk_serif.xml"
                        echo "    </family>" >> "$PAYLOADS/cjk_serif.xml"

                        # CJK mono
                        echo "    <family $LANG_TAG>" > "$PAYLOADS/cjk_mono.xml"
                        for W in 100 200 300 400 500 600 700 800 900; do
                            echo "        <font weight=\"$W\" style=\"normal\" index=\"$INDEX\" postScriptName=\"NotoSansCJK${LANG_PREFIX}-Thin\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$PAYLOADS/cjk_mono.xml"
                        done
                        echo "        <font weight=\"1000\" style=\"normal\" index=\"$INDEX\" postScriptName=\"NotoSansCJK${LANG_PREFIX}-Black\">NotoSansCJK${LANG_PREFIX}-Black.otf</font>" >> "$PAYLOADS/cjk_mono.xml"
                        echo "    </family>" >> "$PAYLOADS/cjk_mono.xml"

                        # Combined payload
                        cat "$PAYLOADS/cjk_sans.xml" "$PAYLOADS/cjk_serif.xml" "$PAYLOADS/cjk_mono.xml" > "$PAYLOADS/cjk_payload.xml"
                        cat << EOF >> "$PAYLOADS/cjk_payload.xml"
    <family $LANG_TAG>
        <font weight="400" style="normal" index="$INDEX" postScriptName="NotoSansCJKjp-Regular">NotoSansCJK-Regular.ttc</font>
        <font weight="400" style="normal" index="$INDEX" fallbackFor="serif" postScriptName="NotoSerifCJKjp-Regular">NotoSerifCJK-Regular.ttc</font>
    </family>
EOF
                        replace_cjk_family "<family $LANG_TAG>" "$PAYLOADS/cjk_payload.xml" "$TARGET"
                    done
                fi

                # Re-inject Unicode font set fragment (repatch starts from the
                # unpatched backup, so the fragment must be re-added every time).
                FRAGMENT="$MODDIR/config/fonts_fragment.xml"
                if [ -f "$FRAGMENT" ] && ! grep -q 'Inject Fragment' "$TARGET" 2>/dev/null; then
                    awk -v block_file="$FRAGMENT" '
                        BEGIN {
                            while ((getline line < block_file) > 0) { block = block line "\n" }
                            close(block_file)
                        }
                        /^[[:space:]]*<\/familyset>/ { printf "%s", block }
                        { print }
                    ' "$TARGET" > "${TARGET}.uni" && mv -f "${TARGET}.uni" "$TARGET"
                    ui_print "  -> Unicode fragment re-injected into $FILE"

                    if [ "$FILE" = "font_fallback.xml" ]; then
                        FB_CTX="u:object_r:system_font_fallback_file:s0"
                        chcon "$FB_CTX" "$TARGET" 2>/dev/null \
                            || setfattr -n security.selinux -v "$FB_CTX" "$TARGET" 2>/dev/null
                    fi
                fi

                ui_print "  -> $FILE re-patched"
            fi
        done
    done

    rm -rf "$PAYLOADS"
    ui_print ""
    ui_print "XML re-patching complete. Reboot to apply."
}

# ==========================================
# Main
# ==========================================
case "${1:-}" in
    --repatch)
        repatch_xml
        ;;
    *)
        update_fonts
        ;;
esac
