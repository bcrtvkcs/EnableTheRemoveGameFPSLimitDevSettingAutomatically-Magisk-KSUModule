#!/system/bin/sh

MODDIR="/data/adb/modules/EnableTheRemoveGameFPSLimitDevSettingAutomatically"

# Update module status
update_status() {
    local status_text="$1"
    local status_emoji="$2"
    local new_description="description=Status: $status_text $status_emoji\\\\nIt keeps the developer options setting that removes the 60 Hz frame rate limit in games enabled after every reboot."
    
    sed -i "s|^description=.*|$new_description|" "$MODDIR/module.prop"
    echo "EnableTheRemoveGameFPSLimitDevSettingAutomatically: $status_text" >> /dev/kmsg
}

PROP_NAME="debug.graphics.game_default_frame_rate.disabled"

# Check if a value represents "enabled"
is_enabled() {
    case "$1" in
        true|1) return 0 ;;
        *)      return 1 ;;
    esac
}

# Detect format from an existing value: "string", "numeric", or "unknown"
detect_format() {
    case "$1" in
        true|false) echo "string"  ;;
        1|0)        echo "numeric" ;;
        *)          echo "unknown" ;;
    esac
}

# Get the "enabled" value for a given format
enabled_value_for() {
    case "$1" in
        numeric) echo "1"    ;;
        *)       echo "true" ;;
    esac
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

# Check current value and detect format
current_value=$(getprop "$PROP_NAME")
detected_format=$(detect_format "$current_value")
echo "EnableTheRemoveGameFPSLimitDevSettingAutomatically: current value = '$current_value' (format: $detected_format)" >> /dev/kmsg

if is_enabled "$current_value"; then
    update_status "Already Enabled ($detected_format format)" "✅"
    echo "EnableTheRemoveGameFPSLimitDevSettingAutomatically: already enabled, skipping" >> /dev/kmsg
else
    # Set the property using the detected format
    update_status "Setting the Property" "⏳"
    set_value=$(enabled_value_for "$detected_format")
    echo "EnableTheRemoveGameFPSLimitDevSettingAutomatically: setting '$set_value' ($detected_format format)" >> /dev/kmsg
    resetprop "$PROP_NAME" "$set_value"

    # Verify
    new_value=$(getprop "$PROP_NAME")
    echo "EnableTheRemoveGameFPSLimitDevSettingAutomatically: new value = '$new_value'" >> /dev/kmsg

    if is_enabled "$new_value"; then
        actual_format=$(detect_format "$new_value")
        update_status "Success ($actual_format format)" "✅"
        echo "EnableTheRemoveGameFPSLimitDevSettingAutomatically: successfully enabled" >> /dev/kmsg
    else
        # Fallback: try the other format
        if [ "$set_value" = "true" ]; then
            fallback_value="1"
            fallback_format="numeric"
        else
            fallback_value="true"
            fallback_format="string"
        fi
        echo "EnableTheRemoveGameFPSLimitDevSettingAutomatically: first attempt failed, trying fallback '$fallback_value' ($fallback_format format)" >> /dev/kmsg
        resetprop "$PROP_NAME" "$fallback_value"

        new_value=$(getprop "$PROP_NAME")
        echo "EnableTheRemoveGameFPSLimitDevSettingAutomatically: fallback new value = '$new_value'" >> /dev/kmsg

        if is_enabled "$new_value"; then
            actual_format=$(detect_format "$new_value")
            update_status "Success ($actual_format format)" "✅"
            echo "EnableTheRemoveGameFPSLimitDevSettingAutomatically: successfully enabled via fallback" >> /dev/kmsg
        else
            update_status "Failed" "❌"
            echo "EnableTheRemoveGameFPSLimitDevSettingAutomatically: failed to set property (tried both formats)" >> /dev/kmsg
        fi
    fi
fi

echo "EnableTheRemoveGameFPSLimitDevSettingAutomatically: script completed" >> /dev/kmsg
