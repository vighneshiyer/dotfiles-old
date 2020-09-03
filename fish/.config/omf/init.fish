#### ASSUME THAT ALL BASH SCRIPT SOURCING IS DONE BEFORE MOVING INTO INIT FISH
# Enable vi mode
set -U fish_cursor_insert line
set -U fish_cursor_replace_one underscore
fish_vi_key_bindings
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
alias rm 'rm -i -r'
alias mv 'mv -i'

## ls
alias sl 'ls'
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
alias ...... 'cd ../../../../..'
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
alias vim 'nvim'
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
alias newterm 'silent termite -d (pwd)'

## Tool Aliases
alias vivado 'vivado -nolog -nojournal'

function tp
    xinput set-prop "TPPS/2 IBM TrackPoint" "libinput Accel Speed" 1;
end

alias list 'du -ahd1 | sort -h'

## t480 specific
alias touchpad_on 'xinput set-prop "13" "Device Enabled" 1'
alias touchpad_off 'xinput set-prop "13" "Device Enabled" 0'
alias hdmi_left 'xrandr --output eDP1 --auto --output HDMI2 --auto --primary --left-of eDP1'
alias hdmi_right 'xrandr --output eDP1 --auto --output HDMI2 --auto --primary --right-of eDP1'
alias hdmi_above 'xrandr --output eDP1 --auto --output HDMI2 --auto --primary --above eDP1'
alias hdmi_dup 'xrandr --output eDP1 --auto --output HDMI2 --auto --same-as eDP1'
alias hdmi_off 'xrandr --output HDMI2 --off'
alias dp_left 'xrandr --output eDP1 --auto --output DP1 --auto --primary --left-of eDP1'
alias dp_right 'xrandr --output eDP1 --auto --output DP1 --auto --primary --right-of eDP1'
alias dp_left_scale 'xrandr --fb 6400x2400 --output eDP1 --mode 2560x1440 --pos 3840x0 --output DP1 --primary --mode 1920x1200 --pos 0x0 --scale 1.2x1.2 --filter bilinear'
alias dp_right_scale 'xrandr --fb 5824x2400 --output eDP1 --mode 2560x1440 --pos 0x0 --output DP1 --primary --mode 1920x1200 --pos 3072x0 --scale 1.3x1.3 --filter bilinear'
alias dp_right_scale2 'xrandr --fb 6720x4000 --output eDP1 --mode 2560x1440 --pos 0x0 --output DP1 --primary --mode 1920x1200 --pos 3840x0 --scale 1.5x1.5'
alias dp_off 'xrandr --output DP1 --off'
alias nvidia_auto 'echo auto | sudo tee /sys/bus/pci/devices/0000:01:00.0/power/control'

# For launching (usually graphical) applications that produce lots of junk printed out
function silent
    nohup $argv </dev/null >/dev/null 2>&1 &
end
alias pdf 'silent zathura'
alias qpdf 'silent qpdfview'
function pdfdump
    pdftk $argv dump_data output $argv.pdfdata
    echo \
"BookmarkBegin
BookmarkTitle: Example Bookmark Title
BookmarkLevel: 1
BookmarkPageNumber: 3"
end
function pdfupdate
    pdftk $argv update_info $argv.pdfdata output $argv.modified
    mv -f $argv.modified $argv
    rm -f $argv.pdfdata
end
alias office 'silent libreoffice'
abbr -a cpr rsync -ah --progress
abbr -a yt-audio "youtube-dl -f \"bestaudio\" -o \" %(title)s.%(ext)s\" --user-agent \"Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)\""

### VNC
function vnc
    vncserver -geometry 2560x1440 2>&1 | grep ^New | awk '{print \$6;}' | tee .vivnc2 | awk -F: '{print \$1\":\"5900+\$2\" `whoami`@\"\$1}' > .vivnc2
end
alias vncnum 'ps -fu `whoami` | grep -i vnc | head -n1 | awk '"'"'{print $9;}'"'"
alias vnckill "cat ~/.vivnc2 | xargs vncserver -kill"
alias bwrcvnc 'ssh -L 5901:`ssh vighnesh.iyer@bwrcrdsl-2.eecs.berkeley.edu "cat ~/.vivnc2"`'

## VNC resolution adjustment
#alias fixcols 'shopt -s checkwinsize'
#alias big 'xrandr -s 1920x1200; fixcols'
#alias vbig 'xrandr -s 2560x1440; fixcols'
#alias s1080 'xrandr -s 1920x1080; fixcols'
#alias s1024 'xrandr -s 1024x768; fixcols'
#alias small 'xrandr -s 1280x800; fixcols'

## SSH Aliases
alias ssh_ramnode 'ssh -i ~/.ssh/ramnode_id_rsa vighnesh@23.226.231.82'
alias ssh_hpse 'ssh hpse-11.eecs.berkeley.edu -l cs199-ban -Y'
alias ssh_bwrc 'ssh bwrcrdsl-4.eecs.berkeley.edu -l vighnesh.iyer -X'
alias ssh_rdsl1 'ssh -X vighnesh.iyer@bwrcrdsl-1.eecs.berkeley.edu'
alias ssh_rdsl2 'ssh -X vighnesh.iyer@bwrcrdsl-2.eecs.berkeley.edu'
alias ssh_rdsl3 'ssh -X vighnesh.iyer@bwrcrdsl-3.eecs.berkeley.edu'
alias ssh_rdsl6 'ssh -X vighnesh.iyer@bwrcrdsl-6.eecs.berkeley.edu'
alias ssh_dp690 'ssh vighnesh.iyer@dp690-12.eecs.berkeley.edu'
alias ssh_241 'ssh root@192.168.192.241'
alias ssh_240 'ssh root@192.168.192.240'
alias ssh_151 'ssh eecs151-taa@c125m-12.eecs.berkeley.edu'
alias ssh_151_master 'ssh eecs151@c125m-12.eecs.berkeley.edu'
alias ssh_290 'ssh ee290-2-aav@eda-1.eecs.berkeley.edu'

## LSF Aliases
alias noemail "set -gx LSB_JOB_REPORT_MAIL n"
alias yesemail "set -gx LSB_JOB_REPORT_MAIL y"

## Directory Aliases
alias hurricane_zc706='cd /tools/projects/vighneshiyer/hurricane-zc706/zc706'
alias hurricane_fesvr='cd /tools/projects/vighneshiyer/hurricane-fesvr'
alias hurricane_riscv_tests='cd /tools/projects/vighneshiyer/hurricane-riscv-tests/xhbwif'
alias splash_tests='cd /tools/projects/vighneshiyer/splash2-testing'
alias hurricane_testing='cd /tools/projects/vighneshiyer/hurricane-testing-host'
alias 151='cd /home/vighnesh/10-school/12-secondary/19-eecs151'
alias 240='cd /home/vighnesh/10-school/13-graduate/06-ee240c'
alias records='silent libreoffice /home/vighnesh/90-notes/personal/Records.ods'
alias log='silent libreoffice /home/vighnesh/90-notes/maxxing/Log.ods'
alias systolic='cd /home/vighnesh/20-research/23-projects/05-systolic'
alias 290='cd /home/vighnesh/10-school/13-graduate/08-ee290c-ml'

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
        ssh -S hw-server-socket -O exit bwrcrdsl-4
    " | ssh -T $who@dp690-12.eecs.berkeley.edu
end

# Internet utilities
alias myip 'curl ipinfo.io/ip'
alias speedtest 'curl -s  https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'

# Create a SSH tunnel to local port 5901 from remote port 5901 (which binds to VNC server)
function vnc_tunnel
    ssh -S vnc-tunnel-socket -O exit bwrcrdsl-4.eecs.berkeley.edu
    ssh -f -N -M -S vnc-tunnel-socket -l vighnesh.iyer -L 5903:bwrcrdsl-4.eecs.berkeley.edu:5903 bwrcrdsl-4.eecs.berkeley.edu
end

function vnc_tunnel_close
    ssh -S vnc-tunnel-socket -O exit bwrcrdsl-4.eecs.berkeley.edu
end

function mount_bwrc
    if mount | grep /mnt/bwrc > /dev/null;
        fusermount -u /mnt/bwrc
    end
    sshfs -o allow_other,uid=1000,gid=1000,IdentityFile=/home/vighnesh/.ssh/id_rsa vighnesh.iyer@bwrcrdsl-4.eecs.berkeley.edu:/tools/B/vighneshiyer/ /mnt/bwrc
end

function unmount_bwrc
    if mount | grep /mnt/bwrc > /dev/null;
        fusermount -u /mnt/bwrc
    end
end

function mount_hpse
    if mount | grep /mnt/hpse > /dev/null;
        fusermount -u /mnt/hpse
    end
    sshfs -o allow_other,uid=1000,gid=1000,IdentityFile=/home/vighnesh/.ssh/id_rsa cs199-ban@hpse-11.eecs.berkeley.edu:/home/cc/cs199/fa13/class/cs199-ban /mnt/hpse
end

function unmount_hpse
    if mount | grep /mnt/hpse > /dev/null;
        fusermount -u /mnt/hpse
    end
end

function mount_eda
    if mount | grep /mnt/eda > /dev/null;
        fusermount -u /mnt/eda
    end
    sshfs -o allow_other,uid=1000,gid=1000,IdentityFile=/home/vighnesh/.ssh/id_rsa ee290-2-aav@eda-1.eecs.berkeley.edu:/scratch/ee290-2-aav /mnt/eda
end

function unmount_eda
    if mount | grep /mnt/eda > /dev/null;
        fusermount -u /mnt/eda
    end
end

# PATH manipulation
set -gx PATH /opt/cisco/anyconnect/bin /opt/miniconda3/bin /opt/Xilinx/Vivado/2019.1/bin /usr/local/go/bin /opt/cabal/bin ~/.scripts $PATH
set -gx RISCV /opt/riscv-esp-tools-290
#set -gx RISCV /opt/riscv-esp-tools
#set -gx RISCV /opt/riscv-master
set -gx PATH $RISCV/bin $PATH
set -gx LD_LIBRARY_PATH $RISCV/lib $LD_LIBRARY_PATH
set -gx EDITOR nvim
#set -gx FIRESIM_STANDALONE 1

source /opt/miniconda3/etc/fish/conf.d/conda.fish

# This function is called every time Enter is hit when in a terminal
# The working directory is written to a tempfile, which is read by i3 if you want a new terminal with the same working directory
function dostuff --on-event fish_prompt
    pwd > /tmp/whereami
end

set -gx TERMINFO /lib/terminfo
xset r rate 250 60

# Symbiotic EDA Formal Verif Course
set -gx PATH /home/vighnesh/20-research/23-projects/17-formal/symbiotic_intro_course/bin $PATH
set -gx SYMBIOTIC_LICENSE /home/vighnesh/20-research/23-projects/17-formal/symbiotic_intro_course/symbiotic.lic
