# Base Install
Install Ubuntu 18.04.1 LTS from a USB drive. Use Rufus to create a bootable USB from the latest 18.04 ISO image.

I'm not using Ubuntu 16.04 due to issues with it working with the latest NVIDIA proprietary driver (for the MX150).

This document will cover T480 specific stuff I had to configure.

# Trackpoint
libinput has regressed from Ubuntu 16.04 which causes poor functionality of the Thinkpad trackpoint.
Install the latest libinput from source which fixes the regression

```
sudo apt-get build-dep libinput
sudo apt-get install libgtk-3-dev check valgrind libsystemd-dev
git clone https://gitlab.freedesktop.org/libinput/libinput
cd libinput
meson --prefix=/usr builddir/ -Ddocumentation=false
ninja -C builddir/
sudo ninja -C builddir/ install
```

Make sure to install any dependencies that `meson` complains about before running `ninja`. Reboot after installing libinput.

Now, use the standard GNOME mouse settings dialog to push the trackpoint speed to the max. But I found that insufficient still. To push the speed even higher:

```
cd /sys/devices/platform/i8042/serio1/serio2/
echo 255 | sudo tee sensitivity
```

Now things are back to normal, like with Ubuntu 16.04. To make this permanent (across reboots):

Add this:

```
SUBSYSTEM=="serio", DRIVERS=="psmouse", DEVPATH=="/sys/devices/platform/i8042/serio1/serio2", ATTR{sensitivity}="255", ATTR{speed}="97"
```

in the file `/etc/udev/rules.d/trackpoint.rules`

# NVIDIA Driver
Using the GNOME drivers dialog, enable all repo sources (including closed-source stuff) and install the stable NVIDIA proprietary driver (nvidia-390). Reboot.

If you want to use NVIDIA graphics, `sudo prime-select nvidia` and reboot. Use `lspci -k` and `glxinfo | grep NVIDIA` to check the NVIDIA card is active.

If you want to switch to Intel to save battery, `sudo prime-select intel` and reboot. Due to a bug in something... the NVIDIA card isn't actually powered down, which sucks away 7-10W extra.

Use `sudo powertop` to see the power consumption which should be 7W idle with Intel only and around 15-20W with the NVIDIA card active.

The workaround documented here (https://github.com/stockmind/dell-xps-9560-ubuntu-respin/issues/8) works great!

```
echo auto | sudo tee /sys/bus/pci/devices/0000:01:00.0/power/control
```

Where the PCI device identifier of the NVIDIA card can be found with `lspci | grep 3D`. After running this, the NVIDIA card is actually powered off. Verify with `sudo powertop` which should report 7W consumption. You need to be on battery power for `powertop` to display power consumption.

# Screen Brightness
I had to add a file in `/etc/X11/xorg.conf` with the following:

```
Section "Device"
Identifier "Card0"
Driver "intel"
Option "Backlight" "/sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-eDP-1/intel_backlight/brightness"
EndSection
```

and then `xbacklight` works after logout and back in.

# Wifi
I'm trying to use `nmcli` only. It works easily to connect to unsecured or WPA2 access points.

To list APs: `nmcli d wifi`

## Connecting to EECS-Secure
EECS-Secure is a WPA2 Enterprise (802.1X) secured network.

### EECS-Secure Details from IRIS
These settings should be used to connect to EECS-Secure:

- Wireless Security: WPA2 Enterprise, AES encryption
- EAP Method: PEAP
- Key Type: Automatic
- Phase2 Type: MSCHAPV2
- Identity: Your EECS username
- Password: Your EECS Active Directory (Windows) Password

During the connection process, your wireless client may indicate that the server certificate for EECS-Secure is presented by clearpass.EECS.Berkeley.EDU and issued by InCommon Certification Authority (2048).

### Setting up the connection
```
nmcli con # Check if a EECS-Secure connection already exists
nmcli d # Find your wifi device ifname (wlp3s0 on T480)
nmcli con add type wifi con-name "EECS-Secure" ifname wlp3s0 ssid "EECS-Secure"
nmcli con edit EECS-Secure # Enter interactive connection edit session
nmcli> set wifi-sec.key-mgmt wpa-eap
nmcli> set 802-1x.eap peap
nmcli> set 802-1x.identity "vighnesh.iyer"
nmcli> set 802-1x.phase2-auth mschapv2
nmcli> quit
```

### Using the connection
```
nmcli con up EECS-Secure --ask # Enter your password once and nmcli will store it without it showing up in shell history
```
