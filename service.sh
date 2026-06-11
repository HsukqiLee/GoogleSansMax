#!/system/bin/sh
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
