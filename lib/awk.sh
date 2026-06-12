#!/system/bin/sh
# ==========================================
# 共享 awk 替换函数 (customize.sh + action.sh 共用)
# ==========================================

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
