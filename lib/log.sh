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


# Magisk/KernelSU/APatch installers provide ui_print/abort while customize.sh is sourced.
# Preserve those host callbacks and only provide runtime fallbacks when they are absent.
if ! command -v ui_print >/dev/null 2>&1; then
    ui_print() {
        printf '%s\n' "$1"
    }
fi

log_print() {
    mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null
    printf '[UnicodeFontSet][%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" >> "$LOG_FILE"
}

safe_ui_print() {
    ui_print "$(safe_text "$1")"
}

if ! command -v abort >/dev/null 2>&1; then
    abort() {
        ui_print "$1"
        rm -f "$TEMP_DIR/$CMAP_TOOL_PREFIX".* 2>/dev/null
        release_lock 2>/dev/null || true
        exit 1
    }
fi
