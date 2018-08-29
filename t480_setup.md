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
echo 255 | sudo tee speed # optional
```

Now things are back to normal, like with Ubuntu 16.04.

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
