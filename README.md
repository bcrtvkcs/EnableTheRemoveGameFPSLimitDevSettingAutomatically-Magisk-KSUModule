# Enable The "Remove Game FPS Limit" Dev Setting Automatically

![Overview](https://raw.githubusercontent.com/bcrtvkcs/EnableTheRemoveGameFPSLimitDevSettingAutomatically-Magisk-KSUModule/refs/heads/main/overview.png)

A Magisk / KernelSU module that automatically enables the **"Remove Game FPS Limit"** developer setting on every boot so you don't have to re-enable it manually each time.

## What Does It Do?

Android has a hidden developer option that removes the 60 Hz frame rate cap in games. However, this setting resets to disabled after every reboot. This module sets the system property `debug.graphics.game_default_frame_rate.disabled` to its enabled state automatically after each boot.

## How It Works

1. Waits for the device to fully boot.
2. Reads the current value of `debug.graphics.game_default_frame_rate.disabled` to detect the device's property format.
3. Sets the property to the correct enabled value for that format.
4. Verifies the change and reports the result in the module description.

### Property Format Compatibility

Different devices store this property in different formats:

| Device Type | Disabled Value | Enabled Value |
|---|---|---|
| String format | `false` | `true` |
| Numeric format | `0` | `1` |

The module auto-detects which format your device uses and sets the value accordingly. If the first attempt fails, it automatically falls back to the other format.

## Installation

1. [Download the latest release](https://github.com/bcrtvkcs/EnableTheRemoveGameFPSLimitDevSettingAutomatically-Magisk-KSUModule/releases/latest/download/EnableTheRemoveGameFPSLimitDevSettingAutomatically-Magisk-KSUModule-main.zip).
2. Flash it via **Magisk**, **KernelSU**, or **KernelSU Next**.
3. Reboot the device.
4. Verify that the setting is enabled (see below).

## How to Verify

After reboot, you can check the module status in two ways:

**From the module manager:** The module description will show the current status (e.g. `Status: Success (string format)`).

**From a terminal:**
```bash
getprop debug.graphics.game_default_frame_rate.disabled
```
The output should be `true` or `1` depending on your device.

## Troubleshooting

If the module reports "Failed", check the kernel log for details:

```bash
dmesg | grep EnableTheRemoveGameFPSLimitDevSettingAutomatically
```

This will show each step the module took, including the detected format, attempted values, and any fallback attempts.

## Uninstallation

Remove the module from your module manager (Magisk / KernelSU). The property will revert to its default value on the next reboot. No residual changes are left on the system.

## Compatibility

- Android 8.0+
- Magisk
- KernelSU / KernelSU Next

## Disclaimer

> **I am not responsible** for bricked devices, dead SD cards, thermonuclear war, or you getting fired because the alarm app failed. Please do some research if you have any concerns about features included in this module before flashing it. **YOU** are choosing to make these modifications, and if you point the finger at me for messing up your device, I will laugh at you!

## Issues

If you experience any problems, please open an issue on the [Issues](https://github.com/bcrtvkcs/EnableTheRemoveGameFPSLimitDevSettingAutomatically-Magisk-KSUModule/issues) page.
