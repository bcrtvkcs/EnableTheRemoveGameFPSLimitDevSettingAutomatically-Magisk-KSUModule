#!/system/bin/sh

MODDIR="/data/adb/modules/EnableTheRemoveGameFPSLimitDevSettingAutomatically"

# Update module status
update_status() {
    local status_text="$1"
    local status_emoji="$2"
    local new_description="description=It keeps the developer options setting that removes the 60 Hz frame rate limit in games enabled after every reboot. Status: $status_text $status_emoji"
    
    sed -i "s|^description=.*|$new_description|" "$MODDIR/module.prop"
    echo "EnableTheRemoveGameFPSLimitDevSettingAutomatically: $status_text" >> /dev/kmsg
}

update_status "Starting" "⏳"

# Wait for boot completion
echo "EnableTheRemoveGameFPSLimitDevSettingAutomatically: waiting for boot completion" >> /dev/kmsg
until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 1
done
echo "EnableTheRemoveGameFPSLimitDevSettingAutomatically: boot completed" >> /dev/kmsg
update_status "Boot completed" "✅"

# Wait a bit for system to stabilize
sleep 5

# Check current value
current_value=$(getprop debug.graphics.game_default_frame_rate.disabled)
echo "EnableTheRemoveGameFPSLimitDevSettingAutomatically: current value = $current_value" >> /dev/kmsg

# Set the property
update_status "Setting the Property" "⏳"
resetprop debug.graphics.game_default_frame_rate.disabled true

# Verify
new_value=$(getprop debug.graphics.game_default_frame_rate.disabled)
echo "EnableTheRemoveGameFPSLimitDevSettingAutomatically: new value = $new_value" >> /dev/kmsg

if [ "$new_value" = "true" ]; then
    update_status "Success" "✅"
    echo "EnableTheRemoveGameFPSLimitDevSettingAutomatically: successfully enabled" >> /dev/kmsg
else
    update_status "Failed" "❌"
    echo "EnableTheRemoveGameFPSLimitDevSettingAutomatically: failed to set property" >> /dev/kmsg
fi

echo "EnableTheRemoveGameFPSLimitDevSettingAutomatically: script completed" >> /dev/kmsg
