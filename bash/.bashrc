# Prompt
export PS1="\[$(tput bold)\]\[\033[38;5;82m\][\h\[$(tput sgr0)\] \[$(tput sgr0)\]\[$(tput bold)\]\[\033[38;5;9m\]\w\[$(tput sgr0)\]\[\033[38;5;82m\]]\\$\[$(tput sgr0)\] \[$(tput sgr0)\]"

# LSF envvars and commands
source /tools/support/lsf/conf/profile.lsf
export FTP_PASSIVE_MODE=yes
export LSB_JOB_REPORT_MAIL=n    # Turn LSF emails off

# License Manager for Vivado and Mentor products
source /tools/flexlm/flexlm.sh

## rm
alias rm='rm -i'

## ls
alias l='ls'
alias ll='ls -lFh'
alias la='ls -a'
alias lla='ls -alFh'
alias las='ls -alFh'

## cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias u1='cd ..'
alias u2='cd ../..'
alias u3='cd ../../..'
alias u4='cd ../../../..'
alias u5='cd ../../../../..'

## bash
alias s='source ~/.bashrc'
alias rc='vim ~/.bashrc'
alias rca='vim ~/.bash_aliases'
alias vi='vim'
alias c='clear'

## git
alias gitdiff='git difftool --tool=vimdiff --no-prompt'
alias gs='git status'
alias gpull='git pull'
alias gfetch='git fetch'
alias gpush='git push'

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

# Used for Xorg forwarding
#export DISPLAY=:0.0

# For launching (usually graphical) applications that produce lots of junk printed out
function silent () {
    nohup $@ </dev/null >/dev/null 2>&1 &
}

alias ssh_dp690='ssh dp690-12.eecs.berkeley.edu -l vighnesh.iyer -Y'

# Internet utilities
alias myip='curl ipinfo.io/ip'
alias speedtest='curl -s  https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/users/vighnesh.iyer/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/users/vighnesh.iyer/miniconda3/etc/profile.d/conda.sh" ]; then
#        . "/users/vighnesh.iyer/miniconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/users/vighnesh.iyer/miniconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda initialize <<<

#### PATH

# Linuxbrew (local package manager)
#export PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
#export PATH="$HOME/.bin:$PATH"
#export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/.linuxbrew"
#export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
#export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"

# Riscv toolchain for hurricane-riscv-tests
#export RISCV=/tools/designs/hurricane/riscv-tools-5/install
#export RISCV=/tools/projects/colins/eagleX/install
#export PATH=$PATH:$RISCV/bin

# Xilinx ARM toolchain
#export PATH=$PATH:/tools/xilinx/SDK/2016.2/gnu/arm/lin/bin

# Custom Python3 for hammer
#export PATH="/tools/projects/hammer/python3-bin/:$PATH"
#export PATH="/users/vighnesh.iyer/miniconda3/bin:$PATH"

# EAGLE-X tapeout
#export HAMMER_HOME="/tools/B/vighneshiyer/eagle-chip/vlsi/hammer"
#source /tools/B/vighneshiyer/eagle-chip/vlsi/hammer/sourceme.sh
#cd /tools/B/vighneshiyer/eagle-chip && source sourceme.sh
#export PATH=$PATH:/tools/projects/colins/dtc/dtc-1.4.4
