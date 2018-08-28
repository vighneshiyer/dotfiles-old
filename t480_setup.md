- Install Ubuntu 18.04.1 LTS from USB drive
	- Prep USB drive with Rufus from working computer
- Enable all deb repos and install stable NVIDIA proprietary driver (nvidia-390)
- libinput has regressed from Ubuntu 16.04 which causes poor functionality of the thinkpad trackpoint. So install the latest libinput from source which seems to fix the regression:
	sudo apt-get build-dep libinput 
	sudo apt-get install libgtk-3-dev check valgrind libsystemd-dev
	git clone https://gitlab.freedesktop.org/libinput/libinput
	cd libinput
	meson --prefix=/usr builddir/ -Ddocumentation=false
	ninja -C builddir/
	sudo ninja -C builddir/ install
