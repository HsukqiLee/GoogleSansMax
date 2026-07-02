#!/bin/sh
# Apply GPL-3.0 header to a file if not already present.
# Usage: apply-gpl-header.sh <file>

[ -f "$1" ] || { echo "Usage: $0 <file>"; exit 1; }

if head -n 1 "$1" | grep -q "Copyright" 2>/dev/null; then
    exit 0
fi

GPL_HEADER='# Copyright (C) 2025 Hsukqi Lee <https://github.com/HsukqiLee>
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
'

printf '%s\n\n' "$GPL_HEADER" | cat - "$1" > "${1}.gpl" && mv "${1}.gpl" "$1"
