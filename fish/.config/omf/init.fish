#### ASSUME THAT ALL BASH SCRIPT SOURCING IS DONE BEFORE MOVING INTO INIT FISH

# Fish theme options (bobthefish)
set -g theme_color_scheme solarized
set -g theme_display_user yes
set -g theme_display_git no 
set -g theme_display_git_untracked no
set -g theme_display_git_ahead_verbose no
set -g theme_git_worktree_support yes
set -g default_user root

### General Aliases
## rm
alias rm 'rm -i'

## ls
alias l 'ls'
alias ll 'ls -lFh'
alias la 'ls -a'
alias lla 'ls -alFh'
alias las 'ls -alFh'

## cd
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias u1 'cd ..'
alias u2 'cd ../..'
alias u3 'cd ../../..'
alias u4 'cd ../../../..'
alias u5 'cd ../../../../..'

## bash
alias s 'omf reload'
alias rc 'vim ~/.bashrc'
alias rca 'vim ~/.config/omf/init.fish'
alias vi 'vim'
alias c 'clear'

## git
alias gitdiff 'git difftool --tool=vimdiff --no-prompt'
alias gs 'git status'
alias gsu 'git status -uno'
alias gpull 'git pull'
alias gfetch 'git fetch'
alias gpush 'git push'

## Tool Aliases
alias vivado 'vivado -nolog -nojournal'

# For launching (usually graphical) applications that produce lots of junk printed out
function silent 
    nohup $argv </dev/null >/dev/null 2>&1 &
end

### VNC
function vnc
    vncserver -geometry 2560x1440 2>&1 | grep ^New | awk '{print \$6;}' | tee .vivnc2 | awk -F: '{print \$1\":\"5900+\$2\" `whoami`@\"\$1}' > .vivnc2
end
alias vncnum 'ps -fu `whoami` | grep -i vnc | head -n1 | awk '"'"'{print $9;}'"'"
alias vnckill "cat ~/.vivnc2 | xargs vncserver -kill"
alias bwrcvnc 'ssh -L 5901:`ssh vighnesh.iyer@bwrcrdsl-2.eecs.berkeley.edu "cat ~/.vivnc2"`'

## VNC resolution adjustment
alias fixcols 'shopt -s checkwinsize'
alias big 'xrandr -s 1920x1200; fixcols'
alias vbig 'xrandr -s 2560x1440; fixcols'
alias s1080 'xrandr -s 1920x1080; fixcols'
alias s1024 'xrandr -s 1024x768; fixcols'
alias small 'xrandr -s 1280x800; fixcols'

## SSH Aliases 
alias ssh_ramnode 'ssh vighnesh@23.226.231.82'
alias ssh_ee241b 'ssh hpse-11.eecs.berkeley.edu -l cs199-ban -Y'
alias ssh_eecs151 'ssh c125m-15.eecs.berkeley.edu -l eecs151-tab -Y'
alias ssh_bwrc 'ssh bwrcrdsl-2.eecs.berkeley.edu -l vighnesh.iyer -Y'
alias ssh_rdsl1 'ssh -X vighnesh.iyer@bwrcrdsl-1.eecs.berkeley.edu'
alias ssh_rdsl2 'ssh -X vighnesh.iyer@bwrcrdsl-2.eecs.berkeley.edu'
alias ssh_rdsl3 'ssh -X vighnesh.iyer@bwrcrdsl-3.eecs.berkeley.edu'
alias ssh_rdsl6 'ssh -X vighnesh.iyer@bwrcrdsl-6.eecs.berkeley.edu'
alias ssh_dp690 'ssh vighnesh.iyer@dp690-12.eecs.berkeley.edu'
alias ssh_241 'ssh root@192.168.192.241'
alias ssh_240 'ssh root@192.168.192.240'

## LSF Aliases
alias noemail "set -gx LSB_JOB_REPORT_MAIL n"
alias yesemail "set -gx LSB_JOB_REPORT_MAIL y"

## Directory Aliases
alias hurricane_zc706='cd /tools/projects/vighneshiyer/hurricane-zc706/zc706'
alias hurricane_fesvr='cd /tools/projects/vighneshiyer/hurricane-fesvr'
alias hurricane_riscv_tests='cd /tools/projects/vighneshiyer/hurricane-riscv-tests/xhbwif'
alias splash_tests='cd /tools/projects/vighneshiyer/splash2-testing'
alias hurricane_testing='cd /tools/projects/vighneshiyer/hurricane-testing-host'

# Hurricane ZC706 Aliases (converted from hurricane-zc706 repo to fish compatiable version)
alias power_on_241 'curl -u admin:bwrc "http://192.168.192.230/outlet.cgi?outlet=2&command=1" > /dev/null'
alias power_off_241 'curl -u admin:bwrc "http://192.168.192.230/outlet.cgi?outlet=2&command=0" > /dev/null'
alias power_toggle_241 'curl -u admin:bwrc "http://192.168.192.230/outlet.cgi?outlet=2&command=2" > /dev/null'
alias power_cycle_241 'curl -u admin:bwrc "http://192.168.192.230/outlet.cgi?outlet=2&command=3" > /dev/null'

alias power_on_240 'curl -u admin:bwrc "http://192.168.192.230/outlet.cgi?outlet=1&command=1" > /dev/null'
alias power_off_240 'curl -u admin:bwrc "http://192.168.192.230/outlet.cgi?outlet=1&command=0" > /dev/null'
alias power_toggle_240 'curl -u admin:bwrc "http://192.168.192.230/outlet.cgi?outlet=1&command=2" > /dev/null'
alias power_cycle_240 'curl -u admin:bwrc "http://192.168.192.230/outlet.cgi?outlet=1&command=3" > /dev/null'

# The native fish version of this function doesn't fork off the reverse ssh tunnel properly
function launch_hw_server
    echo 'source ~/.bashrc; launch_hw_server &' | bash
end

function kill_hw_server
    killall hw_server
    set who (whoami);
    printf "
        source ~/.bashrc
        killall hw_server
        ssh -S hw-server-socket -O exit bwrcrdsl-2
    " | ssh -T $who@dp690-12.eecs.berkeley.edu
end

# Internet utilities
alias myip 'curl ipinfo.io/ip'
alias speedtest 'curl -s  https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'

# Create a SSH tunnel to local port 5901 from remote port 5901 (which binds to VNC server)
function vnc_tunnel 
	cd ~
	ssh -S vnc-tunnel-socket -O exit bwrcrdsl-2.eecs.berkeley.edu
	ssh -f -N -M -S vnc-tunnel-socket -l vighnesh.iyer -L 5901:bwrcrdsl-2.eecs.berkeley.edu:5901 bwrcrdsl-2.eecs.berkeley.edu 
end

function vnc_tunnel_close 
	cd ~
	ssh -S vnc-tunnel-socket -O exit bwrcrdsl-2.eecs.berkeley.edu
end

function mount_bwrc 
	cd ~
	fusermount -u /home/vighnesh/bwrc
	sshfs -o allow_other,uid=1000,gid=1000,IdentityFile=/home/vighnesh/.ssh/id_rsa,Ciphers=arcfour,Compression=no vighnesh.iyer@bwrcrdsl-2.eecs.berkeley.edu:/tools/projects/vighneshiyer/ ~/bwrc
	cd ~/bwrc
end

function unmount_bwrc
	fusermount -u /home/vighnesh/bwrc
end

function mount_eecs151
	cd ~
	fusermount -u /home/vighnesh/eecs151
	sshfs -o allow_other,uid=1000,gid=1000,IdentityFile=/home/vighnesh/.ssh/id_rsa eecs151-tab@c125m-15.eecs.berkeley.edu:/home/cc/eecs151/sp17/staff/eecs151-tab ~/eecs151
	cd ~/eecs151
end

function unmount_eecs151
	fusermount -u /home/vighnesh/eecs151
end

function mount_ee241b
	cd ~
	fusermount -u /home/vighnesh/ee241b
	sshfs -o allow_other,uid=1000,gid=1000,IdentityFile=/home/vighnesh/.ssh/id_rsa,Ciphers=arcfour,Compression=no cs199-ban@hpse-13.eecs.berkeley.edu:/home/cc/cs199/fa13/class/cs199-ban ~/ee241b
end

function unmount_ee241b
	fusermount -u /home/vighnesh/ee241b
end

# alias vim to nvim
alias vim 'nvim'

# cd aliases on local machine
alias e_books 'cd /media/sf_sync/E-Books/'
alias college 'cd /media/sf_sync/College/'
alias websites 'cd /media/sf_sync/WEBSITES'

alias astro7b 'cd /media/sf_sync/College/Berkeley_Spring_2017/Astro_7B'
alias eecs151 'cd /media/sf_sync/College/Berkeley_Spring_2017/EECS_151'
alias ee241b 'cd /media/sf_sync/College/Berkeley_Spring_2017/EE_241B'
alias ee123 'cd /media/sf_sync/College/Berkeley_Spring_2017/EE_123'

# repair wallpaper when changing monitors/resolutions
alias wallpaper 'feh --bg-center /media/sf_sync/College/Wallpapers/fascist_league.png'
