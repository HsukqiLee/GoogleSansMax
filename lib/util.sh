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



get_module_target_path() {
    [ -z "$1" ] && return 1
    local original_subdir="${1#/}"
    case "$original_subdir" in
        system_ext/*) echo "$MODPATH/system/$original_subdir" ;;
        *)            echo "$MODPATH/$original_subdir" ;;
    esac
}

write_sha1_atomic() {
    local sha1_value="$1"
    local sha1_file="$2"

    if ! printf '%s' "$sha1_value" > "${sha1_file}.tmp"; then
        log_print "$(safe_printf TXT_LOG_SHA1_WRITE_FAILED "${sha1_file}.tmp")"
        return 1
    fi

    if ! mv -f "${sha1_file}.tmp" "$sha1_file"; then
        log_print "$(safe_printf TXT_LOG_SHA1_MOVE_FAILED "${sha1_file}.tmp" "$sha1_file")"
        rm -f "${sha1_file}.tmp"
        return 1
    fi

    return 0
}

get_safe_sha1_filename() {
    local prefix="$1"
    printf '%s' "$prefix" | tr '/' '_' | tr ' ' '_'
}
