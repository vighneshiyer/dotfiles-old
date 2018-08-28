# Install Linuxbrew

The software on all the bwrcrdsl login nodes is very old. For example the servers have (in `/usr/bin`) git 1.7.1 and gcc 4.4.7. Also a lot of useful utilities are missing. Linuxbrew lets us download and install packages locally (*without sudo*).

Here are instructions from the linuxbrew Github wiki (https://github.com/Linuxbrew/brew/wiki/CentOS6). Be aware, this compiles a bunch of stuff from source, so it will take a while.

## Install Linuxbrew on CentOS 6 without sudo
Building glibc 2.23 requires GCC 4.7 or later, and CentOS 6 provides GCC 4.4, so build GCC from source before building glibc.

```
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

## Install Utilities
Use Linuxbrew to install modern versions of useful tools like `git`, `gcc`, `clang`, `tmux`, `neovim`, `stow`. Unfortunately, `docker` and `vagrant` can't be used without `sudo` access.

## Configure Shell
Bash is alright... fish is much better! But the `fish` formula in Homebrew seems to specifically point to `/usr/bin/sed` when running `./configure`. If you try running `brew install fish` on a BWRC machine, you'll notice a failure with message `/usr/bin/sed not found`.

I have tracked down the responsible commit (in Homebrew/homebrew-core) to e72ab4a98adbef1b734f7773e49fcf9b207a2398. This commit ought to be more intelligent and use `env sed` (or just `sed`) instead of exactly pointing to `/usr/bin/sed` which is actually located at `/bin/sed` on both the BWRC machines (CentOS 6) and my local Ubuntu 18.04. But `sed` in in `/usr/bin/sed` on OSX.

Anyways, to fix it, run `brew edit fish`, manually change `/usr/bin/sed` to `/bin/sed`, save the file, then rerun `brew install fish`.

**TODO:** Upstream formula fix

# Base dotfiles
- Use `.bashrc`, `.bash_alises`, and `.bash_profile` from Github (vighneshiyer/dotfiles)
    - `stow bash_general`
    - `stow bash_alises_bwrc`
- Configure fish
- Install Miniconda
