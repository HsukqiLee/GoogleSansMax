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

# Kill GMS Font Service (Force Google Apps to use our system-wide Google Sans & Noto CJK)

while true; do
    (
        # Wait until proper boot up
        until [ "$(getprop sys.boot_completed)" = "1" ] && [ -d "/data/data" ]; do
            sleep 5
        done

        PM="$(command -v pm)"
        GMSF="com.google.android.gms/com.google.android.gms.fonts"
        UPS=$(ls -d /data/user/* 2>/dev/null)
        
        # Disable GMS' font service for all users
        if [ -n "$PM" ]; then
            for UP in $UPS; do
                USER_ID="${UP##*/}"
                "$PM" disable --user "$USER_ID" "$GMSF.update.UpdateSchedulerService" >/dev/null 2>&1
                "$PM" disable --user "$USER_ID" "$GMSF.provider.FontsProvider" >/dev/null 2>&1
            done
        fi

        # Delete GMS' dynamically downloaded fonts
        GMSFD="com.google.android.gms/files/fonts"
        [ -d /data/fonts ] && rm -rf /data/fonts
        
        for d in /data/user/*/$GMSFD; do
            if [ -d "$d" ]; then
                rm -rf "$d"
            fi
        done
        
        if [ -d "/data/data/$GMSFD" ]; then
            rm -rf "/data/data/$GMSFD"
        fi
    )

    # Sleep for 3 hours before checking again
    sleep 10800
done
