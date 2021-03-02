# My Struggle
- https://github.com/Linuxbrew/brew/wiki/CentOS6
- https://stackoverflow.com/questions/36651091/how-to-install-packages-in-linux-centos-without-root-user-with-automatic-depen

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

- Let's manually build glibc 2.14
    - IMPORTANT: remove miniconda and devtoolset from your .bashrc, you need the system build tools to build glibc 2.14 (without tool versions being too new)
    - Reference: https://unix.stackexchange.com/questions/176489/how-to-update-glibc-to-2-14-in-centos-6-5
- Download tarball: http://ftp.gnu.org/gnu/glibc/
- In tmux session, run
```bash
mkdir ~/glibc_214
wget <> && tar -xzvf <> && cd glibc-2.14
mkdir build
cd build && ../configure --prefix=/users/vighnesh.iyer/glibc_214
bsub -Is "make -j4"
make install
```

This will mostly succeed, but will fail at the end with the following message:
```
test ! -x /users/vighnesh.iyer/sources/glibc-2.14/build/elf/ldconfig || LC_ALL=C LANGUAGE=C \
          /users/vighnesh.iyer/sources/glibc-2.14/build/elf/ldconfig  \
                                       /users/vighnesh.iyer/glibc_214/lib /users/vighnesh.iyer/glibc_214/lib
/users/vighnesh.iyer/sources/glibc-2.14/build/elf/ldconfig: Can't open configuration file /users/vighnesh.iyer/glibc_214/etc/ld.so.conf: No such file or directory
make[1]: Leaving directory `/users/vighnesh.iyer/sources/glibc-2.14'
```
To fix:
```
cp /etc/ld.so.conf ~/glibc_214/etc/.
cp -r /etc/ld.so.conf.d ~/glibc_214/etc/.
```
Rerun `make install`.

Done, now

## JDK
conda install -c conda-jdk

## Chipyard on BWRC
- Run the steps from the Chipyard docs as usual to set up the repo
```bash
git clone git@github.com:ucb-bar/chipyard
cd chipyard
./scripts/init-submodules-no-riscv-tools.sh
```
   - this will take a while, 20-30 minutes

- Install verilator (Chipyard requires version 4.034 as of Chipyard 1.4)
   - From source (this probably doesn't work out of the box on BWRC machines, due to flex/bison versions)
   ```bash
   mkdir ~/verilator
   git clone http://git.veripool.org/git/verilator
   cd verilator
   git checkout v4.034
   autoconf && ./configure && bsub -Is "make" && sudo make install
   ```
   - From package (recommended)
   ```bash
   conda install -c conda-forge verilator
   verilator --version
   Verilator 4.034 2020-05-03 rev UNKNOWN_REV (mod)
   ```

- Set $RISCV to a precompiled tool location (in .bashrc)
```bash
export RISCV=/tools/B/abejgonza/installs
export PATH=$RISCV/bin:$PATH
```
   - Check that the tools are in your path
   ```bash
   riscv64-unknown-elf-gcc -v
   ...
   gcc version 7.2.0 (GCC)
   ```

- Build FIRRTL
```bash
cd chipyard/sims/verilator
bsub -Is "make"
```
   - You will likely get an error that looks like this:
   ```text
   protoc-jar: executing: [/tmp/protocjar10293879504066272150/bin/protoc.exe, -I/tools/B/vighneshiyer/chipyard-1.4/tools/firrtl/src/main/proto, -I/tools/B/vighneshiyer/chipyard-1.4/tools/firrtl/target/protobuf_external, --java_out=/tools/B/vighneshiyer/chipyard-1.4/tools/firrtl/target/scala-2.12/src_managed/main/compiled_protobuf, /tools/B/vighneshiyer/chipyard-1.4/tools/firrtl/src/main/proto/firrtl.proto]
   /tmp/protocjar10293879504066272150/bin/protoc.exe: /lib64/libc.so.6: version `GLIBC_2.14' not found (required by /tmp/protocjar10293879504066272150/bin/protoc.exe)
   [error] java.lang.RuntimeException: protoc returned exit code: 1
   ```
   - The BWRC machines run RHEL 6 which comes with glibc 2.12, but the protobuf compiler dependency of FIRRTL requires glibc 2.14
   - To hack around this, add this to your .bashrc
   ```bash
   export LD_LIBRARY_PATH=/tools/projects/johnwright/install/hack/lib:$LD_LIBRARY_PATH
   ```
      - John built glibc 2.14 from source and created a lib directory that only symlinks `libc-2.14.1.so, libc.a, libc.so, libc.so.6`
      - I have an equivalent directory in `/tools/B/vighnesh.iyer/glibc_214_export/lib`
   - Rerun `make` and try again; the process should finish with a verilator simulator
   - Remove the `LD_LIBRARY_PATH` glibc export from your .bashrc 

conda verilator failed build - build verilator from source
```text
/home/conda/feedstock_root/build_artifacts/verilator_1588864401395/_build_env/bin/x86_64-conda_cos6-linux-gnu-c++ -fvisibility-inlines-hidden -std=c++17 -fmessage-length=0 -march=nocona -mtune=haswell -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O2 -ffunction-sections -pipe -isystem /users/vighnesh.iyer/miniconda3/include -DNDEBUG -D_FORTIFY_SOURCE=2 -O2 -isystem /users/vighnesh.iyer/miniconda3/include -I.  -MMD -I/users/vighnesh.iyer/miniconda3/share/verilator/include -I/users/vighnesh.iyer/miniconda3/share/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=0 -faligned-new -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow     -fvisibility-inlines-hidden -std=c++17 -fmessage-length=0 -march=nocona -mtune=haswell -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O2 -ffunction-sections -pipe -isystem /users/vighnesh.iyer/miniconda3/include -O3 -std=c++11 -I/tools/B/abejgonza/installs/include -I/tools/B/vighneshiyer/chipyard-1.4/tools/DRAMSim2 -I/tools/B/vighneshiyer/chipyard-1.4/sims/verilator/generated-src/chipyard.TestHarness.RocketConfig    -D__STDC_FORMAT_MACROS -DTEST_HARNESS=VTestHarness -DVERILATOR -include /tools/B/vighneshiyer/chipyard-1.4/sims/verilator/generated-src/chipyard.TestHarness.RocketConfig/chipyard.TestHarness.RocketConfig.plusArgs -include /tools/B/vighneshiyer/chipyard-1.4/sims/verilator/generated-src/chipyard.TestHarness.RocketConfig/verilator.h -include /tools/B/vighneshiyer/chipyard-1.4/sims/verilator/generated-src/chipyard.TestHarness.RocketConfig/chipyard.TestHarness.RocketConfig/VTestHarness.h  -DVL_THREADED -std=gnu++14  -c -o SimDRAM.o /tools/B/vighneshiyer/chipyard-1.4/sims/verilator/generated-src/chipyard.TestHarness.RocketConfig/SimDRAM.cc
make[1]: /home/conda/feedstock_root/build_artifacts/verilator_1588864401395/_build_env/bin/x86_64-conda_cos6-linux-gnu-c++: No such file or directory
make[1]: *** [VTestHarness.mk:72: SimDRAM.o] Error 127
make[1]: Leaving directory '/tools/B/vighneshiyer/chipyard-1.4/sims/verilator/generated-src/chipyard.TestHarness.RocketConfig/chipyard.TestHarness.RocketConfig'
make: *** [Makefile:198: /tools/B/vighneshiyer/chipyard-1.4/sims/verilator/simulator-chipyard-RocketConfig] Error 2
```

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
