# BWRC Archive

## Linuxbrew
Here are instructions from the linuxbrew Github wiki (https://github.com/Linuxbrew/brew/wiki/CentOS6). Be aware, this compiles a bunch of stuff from source, so it will take a while.

### Install Linuxbrew on CentOS 6 without sudo
Building glibc 2.23 requires GCC 4.7 or later, and CentOS 6 provides GCC 4.4, so build GCC from source before building glibc.

```bash
bsub -Is "bash" # Execute the commands below from a LSF node
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
PATH=$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH
HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_BUILD_FROM_SOURCE=1 brew install gcc --without-glibc
HOMEBREW_NO_AUTO_UPDATE=1 brew install glibc
# If encountering locale errors in postinstall of glibc, run
# HOMEBREW_NO_AUTO_UPDATE=1 LC_CTYPE=en_GB.UTF-8 brew postinstall glibc
# see issue - https://github.com/Linuxbrew/legacy-linuxbrew/issues/929
HOMEBREW_NO_AUTO_UPDATE=1 brew remove gcc
HOMEBREW_NO_AUTO_UPDATE=1 brew install gcc
```

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
