#!/system/bin/sh
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

# Fallback HTTP download: curl → wget → busybox wget
http_get() {
    local url="$1" out="$2"
    if command -v curl >/dev/null 2>&1; then
        curl -L --retry 3 -s "$url" -o "$out" 2>/dev/null
    elif command -v wget >/dev/null 2>&1; then
        wget --tries=3 -q "$url" -O "$out" 2>/dev/null
    elif busybox wget --help >/dev/null 2>&1; then
        busybox wget --tries=3 -q "$url" -O "$out" 2>/dev/null
    else
        return 1
    fi
    [ -s "$out" ]
}

is_release_only_file() {
    case "$1" in
        system/fonts/*) return 0 ;;
        *) return 1 ;;
    esac
}

get_variant() {
    sed -n 's|^updateJson=.*/update-\([^/]*\)\.json$|\1|p' \
        "$MODDIR/module.prop" 2>/dev/null | head -n 1
}

# ==========================================
# 字体增量更新
# ==========================================
update_fonts() {
    ui_print() { echo "$1"; }

    ui_print "====================================="
    ui_print "  GoogleSansMax Font Updater"
    ui_print "====================================="
    ui_print ""

    VARIANT=$(get_variant)
    case "$VARIANT" in
        Core|Unicode-CBDT|Unicode-COLRv1) ;;
        *)
            ui_print "[!] Cannot determine installed module variant"
            ui_print "    Re-flash the current release to enable hot updates"
            return 1
            ;;
    esac

    MANIFEST_NAME="manifest-${VARIANT}.txt"
    LOCAL_MANIFEST="$LIBDIR/$MANIFEST_NAME"

    # 检查 / 生成 manifest
    if [ ! -f "$LOCAL_MANIFEST" ]; then
        ui_print "[!] Local manifest not found, regenerating..."
        GEN_SCRIPT="$MODDIR/scripts/gen_manifest.sh"
        if [ -f "$GEN_SCRIPT" ]; then
            sh "$GEN_SCRIPT" "$MODDIR" "$LOCAL_MANIFEST"
            if [ $? -eq 0 ] && [ -f "$LOCAL_MANIFEST" ]; then
                ui_print "    Manifest regenerated from local files"
            else
                ui_print "[!] Failed to regenerate manifest locally"
                return 1
            fi
        else
            ui_print "[!] scripts/gen_manifest.sh not found"
            ui_print "    Please re-flash the module to enable hot updates"
            return 1
        fi
    fi

    # 下载远程 manifest
    mkdir -p "$TMPDIR"
    ui_print "[1/4] Checking for updates..."
    REMOTE_MANIFEST="$TMPDIR/$MANIFEST_NAME"
    http_get "$REMOTE_BASE/lib/$MANIFEST_NAME" "$REMOTE_MANIFEST"

    if [ ! -s "$REMOTE_MANIFEST" ]; then
        ui_print "    Failed to check updates (network error)"
        rm -rf "$TMPDIR"
        return 1
    fi

    # 比较 manifest，找出需要更新的文件
    CHANGED=""
    TOTAL_SIZE=0
    COUNT=0
    RELEASE_COUNT=0

    while IFS='|' read -r REMOTE_FILE REMOTE_HASH REMOTE_SIZE; do
        [ -z "$REMOTE_FILE" ] && continue
        [[ "$REMOTE_FILE" == \#* ]] && continue

        LOCAL_ENTRY=$(grep "^${REMOTE_FILE}|" "$LOCAL_MANIFEST" 2>/dev/null)
        LOCAL_HASH=$(echo "$LOCAL_ENTRY" | cut -d'|' -f2)

        # Release fonts are downloaded, generated, moved, or cmap-stripped by
        # CI. Raw repository files are therefore never safe hot-update inputs.
        if is_release_only_file "$REMOTE_FILE"; then
            [ "$REMOTE_HASH" = "$LOCAL_HASH" ] || RELEASE_COUNT=$((RELEASE_COUNT + 1))
            continue
        fi

        if [ "$REMOTE_HASH" != "$LOCAL_HASH" ]; then
            CHANGED="$CHANGED $REMOTE_FILE"
            TOTAL_SIZE=$((TOTAL_SIZE + REMOTE_SIZE))
            COUNT=$((COUNT + 1))
        fi
    done < "$REMOTE_MANIFEST"

    if [ $COUNT -eq 0 ]; then
        if [ $RELEASE_COUNT -gt 0 ]; then
            ui_print "    $RELEASE_COUNT release font(s) changed"
            ui_print "    Install the latest full module ZIP to update them"
        else
            ui_print "    All hot-updatable files are up to date!"
        fi
        rm -rf "$TMPDIR"
        return 0
    fi

    SIZE_MB=$((TOTAL_SIZE / 1048576))
    ui_print "    Found $COUNT file(s) to update (~${SIZE_MB}MB)"
    if [ $RELEASE_COUNT -gt 0 ]; then
        ui_print "    $RELEASE_COUNT font update(s) require the full module ZIP"
    fi
    ui_print ""

    # 下载变更的文件
    ui_print "[2/4] Downloading updated files..."
    SUCCESS=0
    FAIL=0

    for FILE in $CHANGED; do
        ui_print "    Downloading $FILE..."

        # 根据文件类型决定下载目标
        is_release_only_file "$FILE" && continue
        case "$FILE" in
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
        http_get "$REMOTE_BASE/$FILE" "$DEST_DIR/$(basename "$FILE").tmp"
        if [ $? -eq 0 ] && [ -s "$DEST_DIR/$(basename "$FILE").tmp" ]; then
            mv "$DEST_DIR/$(basename "$FILE").tmp" "$DEST_DIR/$(basename "$FILE")"
            chmod 755 "$DEST_DIR/$(basename "$FILE")" 2>/dev/null
            SUCCESS=$((SUCCESS + 1))
        else
            rm -f "$DEST_DIR/$(basename "$FILE").tmp"
            case "$FILE" in
                system/fonts/unicode/*)
                    ui_print "    [!] $FILE is not available via hot-update"
                    ui_print "        Download the full module release to update"
                    ;;
                *)
                    ui_print "    WARNING: Failed to download $FILE"
                    ;;
            esac
            FAIL=$((FAIL + 1))
        fi
    done

    ui_print "    Downloaded: $SUCCESS, Failed: $FAIL"
    ui_print ""

    # 删除远程不再存在的文件
    ui_print "[3/4] Removing stale files..."
    DELETED=0
    while IFS='|' read -r LOCAL_FILE LOCAL_HASH LOCAL_SIZE; do
        [ -z "$LOCAL_FILE" ] && continue
        [[ "$LOCAL_FILE" == \#* ]] && continue

        is_release_only_file "$LOCAL_FILE" && continue
        if ! grep -q "^${LOCAL_FILE}|" "$REMOTE_MANIFEST" 2>/dev/null; then
            TARGET_FILE="$MODDIR/$LOCAL_FILE"
            if [ -f "$TARGET_FILE" ]; then
                rm -f "$TARGET_FILE"
                ui_print "    Removed $LOCAL_FILE"
                DELETED=$((DELETED + 1))
            fi
        fi
    done < "$LOCAL_MANIFEST"

    if [ $DELETED -gt 0 ]; then
        ui_print "    Removed $DELETED stale file(s)"

        # 清理空目录
        for DIR in system/fonts/unicode system/fonts lib; do
            FULLDIR="$MODDIR/$DIR"
            [ -d "$FULLDIR" ] && find "$FULLDIR" -type d -empty -delete 2>/dev/null
        done
    else
        ui_print "    No stale files to remove"
    fi

    if [ $SUCCESS -eq 0 ] && [ $DELETED -eq 0 ]; then
        ui_print "[!] No files were updated"
        rm -rf "$TMPDIR"
        return 1
    fi

    # 重新生成 manifest
    ui_print "[4/4] Regenerating manifest..."
    GEN_SCRIPT="$MODDIR/scripts/gen_manifest.sh"
    if [ -f "$GEN_SCRIPT" ]; then
        sh "$GEN_SCRIPT" "$MODDIR" "$LOCAL_MANIFEST"
        ui_print "    Manifest regenerated from local files"
    else
        ui_print "[!] scripts/gen_manifest.sh not found, falling back to remote manifest"
        cp "$REMOTE_MANIFEST" "$LOCAL_MANIFEST"
    fi

    # 更新 module.prop versionCode
    if [ -f "$MODDIR/module.prop" ]; then
        OLD_CODE=$(grep '^versionCode=' "$MODDIR/module.prop" | cut -d'=' -f2)
        NEW_CODE=$((OLD_CODE + 1))
        sed -i "s/^versionCode=.*/versionCode=$NEW_CODE/" "$MODDIR/module.prop"
    fi

    # 清理
    rm -rf "$TMPDIR"

    ui_print "Update complete!"
    ui_print ""
    ui_print "Updated $SUCCESS file(s). Reboot to apply."
    if [ $RELEASE_COUNT -gt 0 ]; then
        ui_print "Install the latest full module ZIP for font updates."
    fi
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

                    # monospace (no italic — NotoSansMono has no slant; italic falls through to sans-serif italic)
                    echo '    <family name="monospace">' > "$PAYLOADS/mono.xml"
                    for W in $WEIGHTS; do
                        echo "        <font weight=\"$W\" style=\"normal\">NotoSansMono-VF.ttf<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$PAYLOADS/mono.xml"
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

                        #                         CJK sans
                        echo "    <family $LANG_TAG>" > "$PAYLOADS/cjk_sans.xml"
                        for W in 100 200 300 400 500 600 700 800 900; do
                            echo "        <font weight=\"$W\" style=\"normal\" index=\"$INDEX\" postScriptName=\"NotoSansCJK${LANG_PREFIX}-Thin\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$PAYLOADS/cjk_sans.xml"
                        done
                        echo "    </family>" >> "$PAYLOADS/cjk_sans.xml"

                        # CJK serif
                        echo "    <family $LANG_TAG>" > "$PAYLOADS/cjk_serif.xml"
                        for W in 200 300 400 500 600 700 800 900; do
                            echo "        <font weight=\"$W\" style=\"normal\" index=\"$INDEX\" fallbackFor=\"serif\" postScriptName=\"NotoSerifCJK${LANG_PREFIX}-ExtraLight\">NotoSerifCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$PAYLOADS/cjk_serif.xml"
                        done
                        echo "    </family>" >> "$PAYLOADS/cjk_serif.xml"

                        # CJK mono
                        echo "    <family $LANG_TAG>" > "$PAYLOADS/cjk_mono.xml"
                        for W in 100 200 300 400 500 600 700 800 900; do
                            echo "        <font weight=\"$W\" style=\"normal\" index=\"$INDEX\" postScriptName=\"NotoSansCJK${LANG_PREFIX}-Thin\">NotoSansCJK-VF.otf.ttc<axis tag=\"wght\" stylevalue=\"$W\" /></font>" >> "$PAYLOADS/cjk_mono.xml"
                        done
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

                # Fix SELinux context
                SYS_CTX="u:object_r:system_font_fallback_file:s0"
                [ "$FILE" = "font_fallback.xml" ] || SYS_CTX="u:object_r:system_file:s0"
                chcon "$SYS_CTX" "$TARGET" 2>/dev/null \
                    || setfattr -n security.selinux -v "$SYS_CTX" "$TARGET" 2>/dev/null \
                    || ui_print "  ! Could not set context on $TARGET"

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

                    # Fix SELinux context after fragment injection
                    SYS_CTX="u:object_r:system_font_fallback_file:s0"
                    [ "$FILE" = "font_fallback.xml" ] || SYS_CTX="u:object_r:system_file:s0"
                    chcon "$SYS_CTX" "$TARGET" 2>/dev/null \
                        || setfattr -n security.selinux -v "$SYS_CTX" "$TARGET" 2>/dev/null
                fi

                insert_priority_fallback \
                    "$TARGET" "$MODDIR/config/fonts_priority_fragment.xml"

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
