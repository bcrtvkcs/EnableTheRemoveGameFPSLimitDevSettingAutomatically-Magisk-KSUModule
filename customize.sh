#!/system/bin/sh

# Check Android version
if [ "$API" -lt 26 ]; then
    abort "Android 8.0 or higher required!"
fi

ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━"
ui_print "Enable The Remove Game FPS Limit Dev Setting Automatically"
ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━"
ui_print ""
ui_print "- Device: $(getprop ro.product.model)"
ui_print "- Android: $(getprop ro.build.version.release)"
ui_print "- Module path: $MODPATH"
ui_print ""

# Check current status
current_value=$(getprop debug.graphics.game_default_frame_rate.disabled)
case "$current_value" in
    true)  ui_print "- Current status: enabled (string format: true)" ;;
    1)     ui_print "- Current status: enabled (numeric format: 1)" ;;
    false) ui_print "- Current status: disabled (string format: false)" ;;
    0)     ui_print "- Current status: disabled (numeric format: 0)" ;;
    "")    ui_print "- Current status: not set (will be auto-detected on boot)" ;;
    *)     ui_print "- Current status: unknown value '$current_value'" ;;
esac

# Set permissions
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm $MODPATH/service.sh 0 0 0755

ui_print ""
ui_print "- Initialization completed!"
ui_print ""

# Update status
sed -i '/description/d' $MODPATH/module.prop
echo "description=Status: Installed ✅\\\\nIt keeps the developer options setting that removes the 60 Hz frame rate limit in games enabled after every reboot." >> $MODPATH/module.prop
