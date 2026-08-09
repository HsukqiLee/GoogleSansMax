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


ufs_resolve_api() {
    if [ -n "${API:-}" ]; then
        printf '%s\n' "$API"
        return 0
    fi
    getprop ro.build.version.sdk 2>/dev/null
}

ufs_init_context() {
    API="$(ufs_resolve_api)"
    SELF_MOD_NAME="$(basename "$MODPATH")"
    SHA1_DIR="${UFS_SHA1_DIR:-$MODPATH/sha1}"
    mkdir -p "$SHA1_DIR"
}

ufs_resolve_mirror_path() {
    local candidate=""

    if [ -n "${MAGISKTMP:-}" ]; then
        candidate="$MAGISKTMP/.magisk/mirror"
        if [ -d "$candidate/system" ]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    fi

    if command -v magisk >/dev/null 2>&1; then
        candidate="$(magisk --path 2>/dev/null)/.magisk/mirror"
        if [ -d "$candidate/system" ]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    fi

    return 1
}

ufs_manager_arch_to_abi() {
    case "${ARCH:-}" in
        arm64) printf '%s\n' "arm64-v8a" ;;
        arm)   printf '%s\n' "armeabi-v7a" ;;
        x64)   printf '%s\n' "x86_64" ;;
        x86)   printf '%s\n' "x86" ;;
        *)     return 1 ;;
    esac
}
