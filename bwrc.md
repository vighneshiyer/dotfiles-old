# My Struggle
- https://github.com/Linuxbrew/brew/wiki/CentOS6
- https://stackoverflow.com/questions/36651091/how-to-install-packages-in-linux-centos-without-root-user-with-automatic-depen

## Login and Compute Servers

## VPN
- ssh tunnel alternative
- use globalprotect client on OSX or Windows
- use openconnect package from AUR
    - gpclient for SAML auth

## SSH Setup - Keys

## Basic Bash Setup
- .bashrc
    - flexlm, lsf scripts
    - set PS1
- set .bash_profile

## LSF
- bhosts, bjobs, bkill, bsub

## GUI sessions
- x2go and nomachine only options

- avoid executing any .bashrc stuff for a login shell
- add the following at the top of .bashrc
```bash
[[ $- == *i* ]] || return
```

## tmux
https://superuser.com/questions/1330824/how-to-stop-tmux-from-launching-login-shells/1330842
You need to modify your .tmux.conf like this:

    To disable this behaviour, add to ~/.tmux.conf:

    set -g default-command "${SHELL}"

## packages and build issues

- I need a package manager to replace all the outdated packages on the BWRC machines
- Realized that linuxbrew isn't very functional and is very slow to use, also difficult to update packages and they were often built wrong (wrong location, OSX specific details, etc.)
    - I still have my linuxbrew directory as a backup
- Tried Junest but Centos 6 is just too old and the kernel is too old period
- Finally saw that conda was a good general purpose non-root package manager for all kinds of packages (tmux, tree, fish, git, coreutils, etc.)

- Added /opt/rh/devtoolset-8 to my PATH to get more modern gcc
- Installed miniconda3 in home and used the conda-forge channel to get a bunch of general purpose packages
    - git, tree, fish, tmux, coreutils (conda-forge), make, bison
    - dtc (litex-hub) (DOESNT INSTALL DUE TO PYTHON 3.7 or less dependency)!
    - Need to set gmake to make to avoid configure errors
        - `cd ~/miniconda3/bin && ln -s make gmake`

## Neovim
### AppImage/Binary Install Attempt
- Found new problem, neovim wasn't in conda-forge (only the Python bindings)
- Had to install from source or using AppImage
- Chose AppImage, but it requires glibc 2.14 or greater at runtime (we only have glibc 2.12) - this is a very common problem
```bash
cd sources
wget https://github.com/neovim/neovim/releases/download/v0.4.4/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
# expose nvim to path
ln -s ~/sources/squashfs-root/AppRun ~/miniconda3/bin/nvim
```
Then run :PlugInstall.
however this failed since the miniconda git (and the system and miniconda java) both don't work with hard setting ld_library_path to include glibc 2.14. Solution is to compile nvim from source.

### Successfully Installing from Source
- https://github.com/neovim/neovim/wiki/Installing-Neovim#install-from-source
   - Use devtoolset-8
```bash
mkdir ~/neovim
conda install -c conda-forge cmake ninja

# download v0.4.4 tarball
wget https://github.com/neovim/neovim/archive/v0.4.4.tar.gz
tar -xzvf v0.4.4.tar.gz
cd neovim-0.4.4
# patch third-party/cmake/BuildLibvterm.cmake (remove line 30 - CONFIGURE_COMMAND "")
# see: https://github.com/neovim/neovim/issues/12675

bsub -Is "make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS=\"-DCMAKE_INSTALL_PREFIX=$HOME/neovim\""
make install
```


Done, now

## Chipyard on BWRC
### Basic Setup
- Run the steps from the Chipyard docs as usual to set up the repo
    ```bash
    cd /tools/B/<your username>
    git clone git@github.com:ucb-bar/chipyard
    cd chipyard
    ./scripts/init-submodules-no-riscv-tools.sh
    ```
        - this will take a while, 20-30 minutes

### Install Verilator
- Chipyard requires Verilator version 4.034 (as of Chipyard 1.4), build from source
    1. Modify your `.bashrc` to use a specific version of bison and the regular devtoolset-8 (don't add any other stuff to PATH/LD_LIBRARY_PATH):
        ```bash
        source /opt/rh/devtoolset-8/enable
        export PATH="/users/vighnesh.iyer/bison-3.4:$PATH"
        ```

   2. Then build:
      ```bash
      mkdir ~/verilator-4.034
      git clone http://git.veripool.org/git/verilator
      cd verilator
      git checkout v4.034
      autoconf
      ./configure --prefix=$(HOME)/verilator-4.034
      bsub -Is "make"
      make install
      cd ~/verilator-4.034 && verilator --version
      Verilator 4.034 2020-05-03 rev v4.034
      ```

   3. Finally put verilator on your PATH:
      ```bash
      export PATH="$HOME/verilator-4.034/bin:$PATH"
      ```

### Install RISCV toolchain

#### Quick

#### Full Details
   1. Download and unpack the prebuilt tools
      ```bash
      mkdir ~/riscv-1.4
      wget https://github.com/ucb-bar/chipyard-toolchain-prebuilt/archive/chipyard-1.4-bump.zip
      unzip chipyard-toolchain-prebuilt-chipyard-1.4-bump.zip
      cd chipyard-toolchain-prebuilt-chipyard-1.4-bump
      make DESTDIR=$HOME/riscv-1.4 install
      ```

      If you try running the tools as-is, you will get dynamic loading errors:
      ```bash
      ~/riscv-1.4/bin/riscv64-unknown-elf-gcc
      ./riscv64-unknown-elf-gcc: /lib64/libc.so.6: version GLIBC_2.14 not found (required by ./riscv64-unknown-elf-gcc)
      ```

      We need to patch these binaries with a custom dynamic loader and associated libc.

   2. Analyze dynamic dependencies
      ```bash
      cd ~/riscv-1.4/bin && ldd *
      cd ~/riscv-1.4/libexec/gcc/riscv64-unknown-elf/9.2.0 && ldd *
      cd ~/riscv-1.4/riscv64-unknown-elf/bin && ldd *
      ```

      Note the dependencies of each binary. Here is a list of all the dependencies we care about.
      - libc.so.6 => /lib64/libc.so.6
      - libm.so.6 => /lib64/libm.so.6
      - libdl.so.2 => /lib64/libdl.so.2
      - libz.so.1 => /lib64/libz.so.1
      - libmpc.so.3 => not found
      - libmpfr.so.4 => not found
      - libgmp.so.10 => not found
      - /lib64/ld-linux-x86-64.so.2 (program interpreter)

      - for gdb specifically: (not going to bother fixing)
         - libpython2.7.so.1.0 => not found
         - liblzma.so.5 => not found
         - libncursesw.so.5 => /lib64/libncursesw.so.5 (0x0000003ee4a00000)
         - libtinfo.so.5 => /lib64/libtinfo.so.5 (0x0000003eee600000)
         - libexpat.so.1 => /lib64/libexpat.so.1 (0x0000003ee2200000)

   3. Evaluate our plan
      - These binaries depend on:
         - GNU libc with version GLIBC 2.14+ (libc, libm, libdl)
         - libmpc, libmpfr, and libgmp (multiprecision arithmetic libraries)
         - libz (zlib compression/decompression)
      - Our plan is to gather all these libraries' shared objects in our home directory and use `patchelf` to direct the precompiled RISC-V toolchain binaries to use our custom loader, glibc, and other .so's

   4. Build glibc
      - **IMPORTANT**: remove any changes to your $PATH (e.g. adding devtoolset-8, bison); you need the **system** build tools to build glibc 2.14
      - Reference: https://unix.stackexchange.com/questions/176489/how-to-update-glibc-to-2-14-in-centos-6-5
      ```bash
      mkdir ~/glibc-2.14
      wget http://ftp.gnu.org/gnu/glibc/glibc-2.14.tar.gz
      tar -xzvf glibc-2.14.tar.gz
      cd glibc-2.14
      mkdir build && cd build
      ../configure --prefix=/users/vighnesh.iyer/glibc-2.14
      bsub -Is "make -j4"
      make install
      ```
      - This will mostly succeed, but will fail at the end with the following message:
      ```text
      /users/vighnesh.iyer/sources/glibc-2.14/build/elf/ldconfig: Can't open configuration file /users/vighnesh.iyer/glibc_214/etc/ld.so.conf: No such file or directory
      make[1]: Leaving directory /users/vighnesh.iyer/sources/glibc-2.14
      ```
      - To fix:
      ```bash
      cp /etc/ld.so.conf ~/glibc_214/etc/.
      cp -r /etc/ld.so.conf.d ~/glibc_214/etc/.
      ```
      - Rerun `make install`

   5. Install other dependencies
      - Reference https://stackoverflow.com/questions/36651091/how-to-install-packages-in-linux-centos-without-root-user-with-automatic-depen
      - To avoid building from source, download RPMs (CentOS 7) of the required dependencies (use https://pkgs.org/) and extract them
      ```bash
      mkdir ~/sources/rpm && cd ~/sources/rpm
      wget http://mirror.centos.org/centos/7/os/x86_64/Packages/gmp-6.0.0-15.el7.x86_64.rpm
      rpm2cpio gmp-6.0.0-15.el7.x86_64.rpm | cpio -id
      wget http://mirror.centos.org/centos/7/os/x86_64/Packages/libmpc-1.0.1-3.el7.x86_64.rpm
      rpm2cpio libmpc-1.0.1-3.el7.x86_64.rpm | cpio -id
      wget http://mirror.centos.org/centos/7/os/x86_64/Packages/mpfr-3.1.1-4.el7.x86_64.rpm
      rpm2cpio mpfr-3.1.1-4.el7.x86_64.rpm | cpio -id
      http://mirror.centos.org/centos/7/os/x86_64/Packages/zlib-1.2.7-18.el7.x86_64.rpm
      rpm2cpio zlib-1.2.7-18.el7.x86_64.rpm | cpio -id

      cp -r ~/sources/rpm/usr/lib64/* ~/glibc-2.14/lib/.
      ```

   6. Patch binaries
      - Readd devtoolset-8 to your $PATH
      - Install patchelf
         ```bash
         mkdir ~/patchelf-0.12
         git clone git@github.com:NixOS/patchelf.git
         git checkout 0.12
         ./bootstrap.sh
         ./configure --prefix=/users/vighnesh.iyer/patchelf-0.12
         make
         make check
         make install
         ```
         - add patchelf to your $PATH
      - Run `find . -type f -executable -exec patchelf --set-interpreter ~/glibc-2.14/lib/ld-linux-x86-64.so.2 --set-rpath ~/glibc-2.14/lib/ {} \;` in
         - `riscv-1.4/bin`
         - `riscv-1.4/libexec/gcc/riscv64-unknown-elf/9.2.0`
         - `riscv-1.4/riscv64-unknown-elf/bin`
         - Some errors are expected (patchelf: unsupported overlap of SHT_NOTE and PT_NOTE), all the important binaries have been patched regardless (gdb won't work yet)

   7. Set $RISCV and $PATH
      ```bash
      export RISCV="$HOME/riscv-1.4"
      export PATH="$RISCV/bin:$PATH"
      ```

   8. Build DTC (device tree compiler)
      ```bash
      cd ~/ && wget https://git.kernel.org/pub/scm/utils/dtc/dtc.git/snapshot/dtc-1.6.0.tar.gz
      tar -xzvf dtc-1.6.0.tar.gz
      cd dtc-1.6.0
      make
      make install
      mv ~/bin ~/dtc-1.6.0
      ```
      Put dtc-1.6.0 on your $PATH
      ```bash
      export PATH="$HOME/dtc-1.6.0:$PATH"
      ```

   9. Build auxiluary programs (spike+fesvr, pk, riscv-tests)
      - Spike (RISC-V ISA simulator) + Fesvr (host interaction library)
      ```bash
      cd /tools/B/vighnesh.iyer/chipyard/toolchains/riscv-tools/riscv-isa-sim
      git submodule update --init --recursive . # clone only the riscv-isa-sim submodule (requires git in /users/vighnesh.iyer/miniconda3/bin/git)
      mkdir build
      cd build
      ../configure --prefix=$RISCV
      make
      make install
      ```

      - pk (proxy kernel)
      ```bash
      cd .../chipyard/toolchains/riscv-tools/riscv-pk
      git submodule update --init --recursive .
      mkdir build
      cd build
      ../configure --prefix=$RISCV --host=riscv64-unknown-elf
      make
      make install
      ```

      - riscv-tests (RISCV ISA microtests and benchmarks)
      ```bash
      cd .../chipyard/toolchains/riscv-tools/riscv-tests
      git submodule update --init --recursive .
      autoconf
      ./configure --prefix=$RISCV/target
      make
      make install
      ```

      - Test out the tools
      ```bash
      $ which spike
      /users/vighnesh.iyer/riscv-1.4/bin/spike

      $ spike -l ~/riscv-1.4/target/share/riscv-tests/isa/rv64ui-p-add
      ...
      $ echo $?
      0

      $ spike ~/riscv-1.4/target/share/riscv-tests/benchmarks/dhrystone.riscv
      Microseconds for one run through Dhrystone: 392
      Dhrystones per Second:                      2550
      mcycle = 196024
      minstret = 196029
      ```

### Build FIRRTL
   ```bash
   cd chipyard/sims/verilator
   bsub -Is "make"
   ```
   - You will likely get an error that looks like this:
   ```text
   /tmp/protocjar10293879504066272150/bin/protoc.exe: /lib64/libc.so.6: version `GLIBC_2.14' not found (required by /tmp/protocjar10293879504066272150/bin/protoc.exe)
   [error] java.lang.RuntimeException: protoc returned exit code: 1
   ```
   - https://github.com/ucb-bar/chipyard/pull/774/files
   - To hack around this, add this to your .bashrc
   ```bash
   export LD_LIBRARY_PATH=/tools/projects/johnwright/install/hack/lib:$LD_LIBRARY_PATH
   ```
      - John built glibc 2.14 from source and created a lib directory that only symlinks `libc-2.14.1.so, libc.a, libc.so, libc.so.6`
      - I have an equivalent directory in `/tools/B/vighnesh.iyer/glibc_214_export/lib`
   - Rerun `make` and try again; the process should finish with a verilator simulator
   - Remove the `LD_LIBRARY_PATH` glibc export from your .bashrc

## Intro Message
```

 Your BWRC computer accounts have been created.
Below is the initial orientation information.

Send problem reports to:
     bwrc-sysadmins@lists.eecs.berkeley.edu


Each BWRC user has two separate computer accounts for accessing resources:

** A BWRC-only UNIX account for Linux/Solaris

** Your EECS Department-wide Windows account, now extended to BWRC

Additionally, each user has an account on two BWRC websites:

** bwrcwiki.eecs.berkeley.edu

***** User name is NameSurname.
***** Only accessible from within the EECS network. If outside of EECS, please
          log in to a remote desktop server and access from this session.

** bwrc.eecs.berkeley.edu

***** Use CalNet credentials to log in.
***** Accessible from any network.

Passwords - first time setting:

** To get started with your BWRC UNIX account you must go to the BWRC
   IT office (to the left of the conference room) to set your password.

** For BWRC Windows access, if you already have an EECS Windows account
   we will not change your password - just go ahead and start using BWRC.

** If you did not already have an EECS Windows account you can set your
   password at BWRC when you go to set your UNIX password, or you can go
   to the EECS Helpdesk.

Passwords - changing:

** It would be a best practice to set your password in the office with
   a temporary password and then later change it in private. To change:

***** For UNIX, use the "yppasswd" command
***** For Windows, you want to invoke the Task Manager on the remote
      server. To do this, use CTRL-ALT-BKSP instead of the usual CTRL-ALT-DEL.
***** The above may not be supported on all Linux clients.

Access - connectivity clients:

** The BWRC UNIX domain account allows access via "ssh" to all of the Linux
   and Solaris hosts.

** For BWRC Windows servers use a Remote Desktop Protocol client such as
   Terminal Server Client on Linux or Remote Desktop Connection on Windows.

Access - servers and other resources:

** For a list of server resources, please see:
   https://bwrcwiki.eecs.berkeley.edu/

** For more information on printing, CAD Tools, wireless networking, and more:
   https://bwrcwiki.eecs.berkeley.edu/Computing

**

Thank you,
BWRC Sysadmins.
```

# Archive

## Trying to build GMP, MPC, MPFR from source
- Add devtoolset-8 to your $PATH for the following steps
    - Reference: https://stackoverflow.com/questions/9450394/how-to-install-gcc-piece-by-piece-with-gmp-mpfr-mpc-elf-without-shared-libra
    - This was a bad idea since gcc has these libraries themselves as a dependency which makes the build tricky
    - In the end, building MPC didn't work due to linker errors

- Building GMP
   ```bash
   wget https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz
   tar -xvf gmp-6.2.1.tar.xz
   cd gmp-6.2.1
   ./configure --prefix=/users/vighnesh.iyer/glibc-2.14
   bsub -Is "make"
   make install
   ```

- Building MPFR
   ```bash
   wget https://www.mpfr.org/mpfr-current/mpfr-4.1.0.tar.gz
   tar -xzvf mpfr-4.1.0.tar.gz
   cd mpfr-4.1.0
   ./configure --prefix=/users/vighnesh.iyer/glibc-2.14 --with-gmp-build=/users/vighnesh.iyer/source/gmp-6.2.1
   bsub -Is "make"
   make install
   cd ~/glibc-2.14/lib
   ln -s libmpfr.so libmpfr.so.4
   ```

- Building MPC
   ```bash
   wget https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz
   tar -xzvf mpc-1.2.1.tar.gz
   cd mpc-1.2.1
   ./configure --prefix=/users/vighnesh.iyer/glibc-2.14 --with-gmp=/users/vighnesh.iyer/glibc-2.14 --with-mpfr=/users/vighnesh.iyer/glibc-2.14
   configure: error: in /users/vighnesh.iyer/sources/mpc-1.2.1
   configure: error: C compiler cannot create executables
   ```
   ```text
   # config.log

   configure:3766: checking whether the C compiler works
   configure:3788: gcc -O2 -pedantic -fomit-frame-pointer -m64 -mtune=skylake -march=broadwell -I/users/vighnesh.iyer/glibc-2.14/include -I/users/vighnesh.iyer/glibc-2.14/include  -    L/users/vighnesh.iyer/glibc-2.14/lib -L/users/vighnesh.iyer/glibc-2.14/lib  conftest.c  >&5
   /opt/rh/devtoolset-8/root/usr/libexec/gcc/x86_64-redhat-linux/8/ld: cannot find /users/vighnesh.iyer/glibc_214/lib/libc.so.6
   /opt/rh/devtoolset-8/root/usr/libexec/gcc/x86_64-redhat-linux/8/ld: cannot find /users/vighnesh.iyer/glibc_214/lib/libc_nonshared.a
   /opt/rh/devtoolset-8/root/usr/libexec/gcc/x86_64-redhat-linux/8/ld: cannot find /users/vighnesh.iyer/glibc_214/lib/ld-linux-x86-64.so.2
   collect2: error: ld returned 1 exit status
   ```
   - this failed and I have no way to fix it without rebuilding gcc with the custom glibc, don't bother with this method
