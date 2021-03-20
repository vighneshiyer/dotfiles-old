# My Struggle

## BWRC Info
- BWRC sysadmin email: bwrc-sysadmins@lists.eecs.berkeley.edu
- BWRC Wiki: bwrcwiki.eecs.berkeley.edu (only accessible within EECS network)
    - Username: NameSurname
- BWRC website: bwrc.eecs.berkeley.edu
    - Username/password: CalNet ID
** For a list of server resources, please see:
   https://bwrcwiki.eecs.berkeley.edu/

** For more information on printing, CAD Tools, wireless networking, and more:
   https://bwrcwiki.eecs.berkeley.edu/Computing
-  For UNIX, use the "yppasswd" command

## Login and Compute Servers

## VPN
- ssh tunnel alternative
- use globalprotect client on OSX or Windows
- use openconnect package from AUR
    - gpclient for SAML auth
- sshuttle -vvvv -r cs199-ban@eda-1.eecs.berkeley.edu 0/0 -x eda-1.eecs.berkeley.edu

## SSH Setup - Keys

## Basic Bash Setup
- .bashrc
    - flexlm, lsf scripts
    - set PS1
   - set colors
   - ser aliases
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

## Modern Tooling
- BWRC servers run on RHEL 6, most software is very old (e.g. git 1.7, gcc 4.4)
- Previously I had used Linuxbrew/Homebrew as a local package manager, but it is hard to keep up to date and ruby is very slow
   - https://github.com/Linuxbrew/brew/wiki/CentOS6
   - https://stackoverflow.com/questions/36651091/how-to-install-packages-in-linux-centos-without-root-user-with-automatic-depen
- I tried using Junest, but CentOS 6 is too old for it to work even with all the workarounds
- Finally settled on **conda** (Miniconda3) which has a bunch of useful packages on the conda-forge channel
   ```bash
   wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
   chmod +x Miniconda3-latest-Linux-x86_64.sh
   ./Miniconda3-latest-Linux-x86_64.sh
   # go through install process
   # add conda to your .bashrc
   conda install -c conda-forge git tmux make bison flex coreutils tree
   ```

### Neovim
- Using the neovim AppImage doesn't work nicely since it is built for glibc 2.14, build from source
- https://github.com/neovim/neovim/wiki/Installing-Neovim#install-from-source
   1. Modify .bashrc
   ```bash
   source /opt/rh/devtoolset-8/enable
   ```
   2. Install dependencies
   ```bash
   conda install -c conda-forge cmake ninja
   ```

   3. Build
   ```bash
   mkdir ~/neovim

   # download v0.4.4 tarball
   wget https://github.com/neovim/neovim/archive/v0.4.4.tar.gz
   tar -xzvf v0.4.4.tar.gz
   cd neovim-0.4.4

   # patch a file
   vim third-party/cmake/BuildLibvterm.cmake # (remove line 30 - CONFIGURE_COMMAND "") # see: https://github.com/neovim/neovim/issues/12675

   bsub -Is "make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS=\"-DCMAKE_INSTALL_PREFIX=$HOME/neovim\""
   make install
   ```

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
      ./configure --prefix /users/vighnesh.iyer/verilator-4.034
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
##### GCC 8.x (good enough for most)
```bash
wget https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.3.0-2020.04.0-x86_64-linux-centos6.tar.gz
tar -xzvf riscv64-unknown-elf-gcc-8.3.0-2020.04.0-x86_64-linux-centos6.tar.gz
mv riscv64-unknown-elf-gcc-8.3.0-2020.04.0-x86_64-linux-centos6 ~/riscv-sifive
```
- Set $RISCV and add to $PATH
```bash
export RISCV="$HOME/riscv-sifive"
export PATH="$RISCV/bin:$PATH"
```

##### GCC 9.x
- Copy the prebuilt and patched tools to your home
```bash
cp -r /users/vighnesh.iyer/riscv-1.4 ~/.
```

- Set $RISCV and add to $PATH
```bash
export RISCV="$HOME/riscv-1.4"
export PATH="$RISCV/bin:$PATH"
```

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

### Build RISC-V Tools and Tests
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

### Build an RTL Simulator
   ```bash
   cd chipyard/sims/verilator
   LD_LIBRARY_PATH=/tools/projects/johnwright/install/hack/lib:$LD_LIBRARY_PATH bsub -Is "make"
   ```
   - If you don't use John's libc hack, you will get an error like this when compiling FIRRTL:
      ```text
      /tmp/protocjar10293879504066272150/bin/protoc.exe: /lib64/libc.so.6: version `GLIBC_2.14' not found (required by /tmp/protocjar10293879504066272150/bin/protoc.exe)
      [error] java.lang.RuntimeException: protoc returned exit code: 1
      ```
   - In the future, you don't have to prepend make invocations with the LD_LIBRARY_PATH hack unless you delete the firrtl build artifacts
   - In the end, you should get a simulator binary:
   ```bash
   $ ls chipyard/sims/verilator
   simulator-chipyard-RocketConfig
   $ make run-binary-fast-hex BINARY=~/riscv-1.4/target/share/riscv-tests/isa/rv64ui-p-add
   $ make run-binary-fast-hex BINARY=~/riscv-1.4/target/share/riscv-tests/benchmarks/dhrystone.riscv
   ```

### Setup HAMMER for VLSI Flow (tsmc28)
   Clone the VLSI repos.
   ```bash
   ./scripts/init-vlsi.sh
   cd vlsi
   git clone git@bwrcrepo.eecs.berkeley.edu:tstech28/hammer-tstech28-plugin
   ```

   Set up the environment and design yaml files.

   Use the SRAM compiler USE_SRAM_COMPILER.

   ```bash
   bsub -Is "make buildfile ENV_YML=\"bwrc-env.yml\" INPUT_CONFS=\"bwrc-tstech28-tools.yml tstech28.yml tstech28-design.yml\" tech_name=tstech28 USE_SRAM_COMPILER=1"
   ```
