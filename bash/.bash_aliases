#### Prompt
export PS1="\[$(tput bold)\]\[\033[38;5;82m\][\h\[$(tput sgr0)\] \[$(tput sgr0)\]\[$(tput bold)\]\[\033[38;5;9m\]\w\[$(tput sgr0)\]\[\033[38;5;82m\]]\\$\[$(tput sgr0)\] \[$(tput sgr0)\]"

#### Envvars
export TERM=xterm-color
export FTP_PASSIVE_MODE=yes
export LSB_JOB_REPORT_MAIL=n    # Turn LSF emails off

#### Sourcing bash scripts

# Source LSF envvars and commands
source /tools/support/lsf/conf/profile.lsf

# Source License Manager for Vivado and Mentor products
source /tools/flexlm/flexlm.sh

# Source hurricane-zc706 specific aliases
#source /tools/projects/vighneshiyer/hurricane-zc706/sourceme.sh

#### PATH
# Xilinx ARM toolchain
#export PATH=$PATH:/tools/xilinx/SDK/2016.2/gnu/arm/lin/bin

# Riscv toolchain for hurricane-riscv-tests
#export RISCV=/tools/designs/hurricane/riscv-tools-5/install
#export RISCV=/tools/projects/colins/eagleX/install
#export PATH=$PATH:$RISCV/bin

# Anaconda3 (Python3 and utilities)
#export PATH=/users/vighnesh.iyer/anaconda3/bin:$PATH

# Linuxbrew (local package manager)
#export PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
#export PATH="$HOME/.bin:$PATH"
#export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/.linuxbrew"
#export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
#export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"

# Custom Python3 for hammer
#export PATH="/tools/projects/hammer/python3-bin/:$PATH"
#export PATH="/users/vighnesh.iyer/miniconda3/bin:$PATH"

# EAGLE-X tapeout
#export HAMMER_HOME="/tools/B/vighneshiyer/eagle-chip/vlsi/hammer"
#source /tools/B/vighneshiyer/eagle-chip/vlsi/hammer/sourceme.sh
#cd /tools/B/vighneshiyer/eagle-chip && source sourceme.sh
#export PATH=$PATH:/tools/projects/colins/dtc/dtc-1.4.4

# LSF aliases
if hash bsub 2>/dev/null; then
    # aliases with LSF
    alias bmake='bsub -q normal make'
    bmakelog() {
        bsub -q normal "make $1 | tee log"
    }
    alias bmakep='bsub -q priority make'
    alias bf='bpeek -f'
    alias bfe='bpeek -f | grep --color --line-buffered -E '"'"'^Error.*'"'"
    alias bfw='bpeek -f | grep --color --line-buffered -E '"'"'^Error.*|^Warning.*'"'"
    alias bvirtuoso='bsub -Is virtuoso &'
    alias bdve='bsub -Is dve -full64 -vpd vcdplus.vpd &'
    alias tmaxgui='bsub -Is tmax &'
    alias iccgui='bsub -Is icc_shell -64bit -gui'
elif hash qsub 2>/dev/null; then
    alias qsub='qsub -l nodes=1:ppn=8'
    alias bmake='qsub make'
    bmakelog() {
        qsub "make $1 | tee log"
    }
else
    # aliases without LSF
    alias bmake='make'
    alias bmakep='make'
    alias virtuoso='virtuoso &'
    alias tmaxgui='tmax &'
fi

# Working folder aliases
alias hurricane_zc706='cd /tools/projects/vighneshiyer/hurricane-zc706/zc706'
alias hurricane_fesvr='cd /tools/projects/vighneshiyer/hurricane-fesvr'
alias hurricane_riscv_tests='cd /tools/projects/vighneshiyer/hurricane-riscv-tests/xhbwif'
alias splash_tests='cd /tools/projects/vighneshiyer/splash2-testing'
alias hurricane_testing='cd /tools/projects/vighneshiyer/hurricane-testing-host'
alias eagle='cd /tools/B/vighneshiyer/eagle-chip'
