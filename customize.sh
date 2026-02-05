#!/system/bin/sh

# Check Android version
if [ "$API" -lt 26 ]; then
    abort "Android 8.0 veya üstü gerekli!"
fi

ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ui_print "Enable The Remove Game FPS Limit Dev Setting Automatically"
ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ui_print ""
ui_print "- Cihaz: $(getprop ro.product.model)"
ui_print "- Android: $(getprop ro.build.version.release)"
ui_print "- Module path: $MODPATH"
ui_print ""

# Check current status
current_value=$(getprop debug.graphics.game_default_frame_rate.disabled)
ui_print "- Current status: $current_value"

# Set permissions
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm $MODPATH/service.sh 0 0 0755

ui_print ""
ui_print "- Initialization completed!"
ui_print "- It will become active after a reboot."
ui_print ""

# Update status
sed -i '/description/d' $MODPATH/module.prop
echo "description=It keeps the developer options setting that removes the 60 Hz frame rate limit in games enabled after every reboot. Status: Installed, reboot required 🔄" >> $MODPATH/module.prop
