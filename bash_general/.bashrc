### General aliases
source ~/.bash_aliases
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

# Used for Xorg forwarding
#export DISPLAY=:0.0

# For launching (usually graphical) applications that produce lots of junk printed out
function silent () {
    nohup $@ </dev/null >/dev/null 2>&1 &
}

# SSH to various servers
alias ssh_ramnode='ssh vighnesh@23.226.231.82'
alias ssh_intovps='ssh www@184.75.242.173 -p 33322'
alias ssh_ee241b='ssh hpse-11.eecs.berkeley.edu -l cs199-ban -Y'
alias ssh_eecs151='ssh c125m-15.eecs.berkeley.edu -l eecs151-tab -Y'
alias ssh_bwrc='ssh bwrcrdsl-2.eecs.berkeley.edu -l vighnesh.iyer -Y'
alias ssh_dp690='ssh dp690-12.eecs.berkeley.edu -l vighnesh.iyer -Y'

# Internet utilities
alias myip='curl ipinfo.io/ip'
alias speedtest='curl -s  https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'
