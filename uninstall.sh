#!/system/bin/sh
# Copyright (C) 2025 Hsukqi Lee <https://github.com/HsukqiLee>
# Portions Copyright (C) 2022-2024 MrCarb0n <https://github.com/MrCarb0n/killgmsfont>
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

# Re-enable GMS Font Service (reverses service.sh persistent pm disable)
# uninstall.sh runs in post-fs-data, before the package manager is ready,
# so wait for boot to complete before issuing pm commands.

i=0
until [ "$(getprop sys.boot_completed)" = "1" ] 2>/dev/null; do
    i=$((i + 1))
    [ "$i" -gt 120 ] && exit 0
    sleep 1
done

PM="$(command -v pm)"
GMSF="com.google.android.gms/com.google.android.gms.fonts"

if [ -n "$PM" ]; then
    for UP in $(ls -d /data/user/* 2>/dev/null); do
        USER_ID="${UP##*/}"
        "$PM" enable --user "$USER_ID" "$GMSF.update.UpdateSchedulerService" >/dev/null 2>&1
        "$PM" enable --user "$USER_ID" "$GMSF.provider.FontsProvider" >/dev/null 2>&1
    done
fi

exit 0
