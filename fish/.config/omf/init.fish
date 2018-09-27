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

## bash/fish
alias s 'omf reload'
alias rc 'vim ~/.bashrc'
alias rca 'vim ~/.config/omf/init.fish'
alias vi 'vim'
alias c 'clear'
alias r 'tput reset'

## git
alias gitdiff 'git difftool --tool=vimdiff --no-prompt'
alias gs 'git status'
alias gsu 'git status -uno'
alias gpull 'git pull'
alias gfetch 'git fetch'
alias gpush 'git push'

## taskwarrior
alias tl 'task list'
alias t 'task'
alias ts 'task sync'
alias taskbackup 'cd ~/.task; and tar czf ~/sensitive-dotfiles/task_backups/task-backup-(date +'%Y%m%d').tar.gz *'

## tree
alias treea 'tree -a -I .git'

## Tool Aliases
alias vivado 'vivado -nolog -nojournal'

## t480 specific
alias touchpad_on 'xinput set-prop "13" "Device Enabled" 1'
alias touchpad_off 'xinput set-prop "13" "Device Enabled" 0'
alias hdmi_left 'xrandr --output eDP1 --auto --output HDMI2 --auto --left-of eDP1'
alias hdmi_right 'xrandr --output eDP1 --auto --output HDMI2 --auto --right-of eDP1'
alias hdmi_off 'xrandr --output HDMI2 --off'
alias dp_left 'xrandr --output eDP1 --auto --output DP1 --auto --left-of eDP1'
alias dp_left_scale 'xrandr --fb 6400x2400 --output eDP1 --mode 2560x1440 --pos 3840x0 --output DP1 --mode 1920x1200 --pos 0x0 --scale 1.2x1.2 --filter bilinear'
alias nvidia_auto 'echo auto | sudo tee /sys/bus/pci/devices/0000:01:00.0/power/control'

# For launching (usually graphical) applications that produce lots of junk printed out
function silent
    nohup $argv </dev/null >/dev/null 2>&1 &
end
alias pdf 'silent qpdfview'

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
alias ssh_intovps='ssh www@184.75.242.173'
alias ssh_ee241b 'ssh hpse-11.eecs.berkeley.edu -l cs199-ban -Y'
#alias ssh_ee241b 'ssh cory.eecs.berkeley.edu -l cs199-ban -Y'
alias ssh_ee142 'ssh hpse-13.eecs.berkeley.edu -l ee142-aay -Y'
alias ssh_eecs151 'ssh c125m-13.eecs.berkeley.edu -l eecs151-tab -Y'
alias ssh_bwrc 'ssh bwrcrdsl-4.eecs.berkeley.edu -l vighnesh.iyer -Y'
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
    ssh -S vnc-tunnel-socket -O exit bwrcrdsl-2.eecs.berkeley.edu
    ssh -f -N -M -S vnc-tunnel-socket -l vighnesh.iyer -L 5903:bwrcrdsl-2.eecs.berkeley.edu:5903 bwrcrdsl-2.eecs.berkeley.edu
end

function vnc_tunnel_close
    ssh -S vnc-tunnel-socket -O exit bwrcrdsl-2.eecs.berkeley.edu
end

function mount_bwrc
    if mount | grep /home/vighnesh/mount/bwrc > /dev/null;
        fusermount -u /home/vighnesh/mount/bwrc
    end
    sshfs -o allow_other,uid=1000,gid=1000,IdentityFile=/home/vighnesh/.ssh/id_rsa,Ciphers=arcfour,Compression=no vighnesh.iyer@bwrcrdsl-2.eecs.berkeley.edu:/tools/projects/vighneshiyer/ ~/mount/bwrc
end

function unmount_bwrc
    if mount | grep /home/vighnesh/mount/bwrc > /dev/null;
        fusermount -u /home/vighnesh/mount/bwrc
    end
end

# alias vim to nvim
alias vim 'nvim'

# PATH manipulation
set -gx PATH ~/dotty-0.9.0-RC1/bin /opt/cisco/anyconnect/bin ~/miniconda3/bin ~/firrtl/utils/bin /opt/diff-so-fancy $PATH
set -gx ROCKETCHIP ~/rocket-chip
set -gx RISCV ~/rocket-chip/riscv-tools
set -gx PATH $RISCV/bin $PATH
