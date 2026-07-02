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

[ -n "$_UFS_LIB_LOADED" ] && return
_UFS_LIB_LOADED=1

if [ -z "$MODPATH" ]; then
    SCRIPT_REAL_PATH="$(readlink -f "$0" 2>/dev/null || echo "$0")"
    MODPATH="${SCRIPT_REAL_PATH%/*}"
fi

LIBDIR="$MODPATH/lib"
LOG_FILE="${MODPATH:-/cache}/ufs.log"

. "$LIBDIR/const.sh"
. "$LIBDIR/lang.sh"
. "$LIBDIR/log.sh"
. "$LIBDIR/lock.sh"
. "$LIBDIR/util.sh"
. "$LIBDIR/xml.sh"
. "$LIBDIR/binary.sh"
. "$LIBDIR/monitor.sh"
. "$LIBDIR/cmap.sh"
