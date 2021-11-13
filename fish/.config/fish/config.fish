# Enable vi mode
set -U fish_cursor_insert line
set -U fish_cursor_replace_one underscore
fish_vi_key_bindings

set -U fish_greeting ""

### General Aliases
alias sudo 'sudo '
function sudo!!
    echo sudo $history[1]
    eval sudo $history[1]
end
alias dmesg 'dmesg --ctime'
## file utilities
alias rm 'rm -i -r'
alias mv 'mv -i'
alias cp 'cp -i'

## ls
#alias sl 'ls'
#alias l 'ls'
#alias ll 'ls -lFh'
#alias la 'ls -a'
#alias lla 'ls -alFh'
#alias las 'ls -alFh'
#set -gx LS_COLORS 'rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'

## exa
alias sl 'exa'
alias l 'exa'
alias ls 'exa'
alias lsl 'exa'
alias ll 'exa -lF'
alias la 'exa -a'
alias lla 'exa -laF'
alias las 'exa -laF'
set -gx LS_COLORS 'rs=0:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:di=01;34:ln=01;36:ex=01;32:*.bak=37:*.cache=37:*.dist=37:*.lock=37:*.log=37:*.old=37:*.orig=37:*.temp=37:*.tmp=37:*.swp=37:*.o=37:*.d=37:*.aux=37:*.bbl=37:*.blg=37:*.lof=37:*.lot=37:*.toc=37:*.class=37:*.pyc=37:*.jpg=38;5;167:*.jpeg=38;5;167:*.JPG=38;5;167:*.png=38;5;167:*.PNG=38;5;167:*.bmp=38;5;167:*.gif=38;5;167:*.jfif=38;5;167:*.tif=38;5;167:*.tiff=38;5;167:*.svg=38;5;167:*.webp=38;5;167:*.dng=38;5;167:*.mp4=38;5;167:*.mpg=38;5;167:*.mpeg=38;5;167:*.mkv=38;5;167:*.webm=38;5;167:*.mov=38;5;167:*.MTS=38;5;167:*.mp3=38;5;167:*.flac=38;5;167:*.ogg=38;5;167:*.wav=38;5;167:*.opus=38;5;167:*.oga=38;5;167:*.m4a=38;5;167:*.wmv=38;5;167:*.txt=33:*.doc=33:*.xls=33:*.xlsx=33:*.docx=33:*.ppt=33:*.pptx=33:*.odt=33:*.ods=33:*.md=33:*.adoc=33:*.pdf=33:*.epub=33:*.djvu=33:*.json=33:*.yaml=33:*.yml=33:*.csv=33:*.c=32:*.cpp=32:*.cc=32:*.scala=32:*.rs=32:*.py=32:*.go=32:*.tex=32:*.js=32:*.html=32:*.sbt=01;04;32:*Makefrag=01;04;32:*Makefile=01;04;32:*.mk=01;04;32:*.sc=01;04;32:*README=01;04;32:*README.md=01;04;32:*.properties=01;04;32:*Cargo.toml=01;04;32:*.iso=35:*.deb=35:*.jar=35:*.a=35:*.so=35:*.7z=35:*.gz=35:*.bz=35:*.bz2=35:*.lzma=35:*.rar=35:*.zip=35:*.rpm=35:*.tar=35:*.xml=35:'

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
alias scd 'cd'
alias dc 'cd'

alias 151 'cd /home/vighnesh/10-school/12-secondary/19-eecs151'
alias labs 'cd /home/vighnesh/10-school/12-secondary/19-eecs151/labs_skeleton/fpga_labs_fa21'
alias labs_ref 'cd /home/vighnesh/10-school/12-secondary/19-eecs151/labs_reference/fpga_labs_fa21_reference'
alias prj 'cd /home/vighnesh/10-school/12-secondary/19-eecs151/project_skeleton/project_skeleton_fa21'
alias prj_ref 'cd /home/vighnesh/10-school/12-secondary/19-eecs151/project_reference/project_reference_fa21'
alias website 'cd /home/vighnesh/10-school/12-secondary/19-eecs151/website_fa21'

## bash/fish
alias s 'source ~/.config/fish/config.fish'
alias rc 'vim ~/.config/fish/config.fish'
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
set -gx EDITOR nvim

## For launching (usually graphical) applications that print out lots of junk
function silent
    nohup $argv </dev/null >/dev/null 2>&1 &
end

## Tool Aliases
alias diff 'diff --color=auto'
alias grep 'grep --color=auto'
alias rg 'rg --smart-case'
alias lsblk 'lsblk -f'
alias newterm 'silent alacritty -d (pwd)'
alias vivado 'vivado -nolog -nojournal'
alias sbt 'sbt -Dsbt.supershell=false'
set -gx SBT_OPTS
alias treea 'tree -a -I .git'
alias list 'du -ahd1 | sort -h'
alias df 'df -h'
alias free 'free -mh'
function ff
    find . -type f -iname "*$argv*"
end
alias vlc 'silent vlc'
alias pdf 'silent zathura'
alias qpdf 'silent qpdfview'
alias opdf 'silent okular'
alias office 'silent libreoffice'
alias gtkwave 'silent gtkwave'
abbr -a cpr rsync -ah --progress
abbr -a rsync_remote rsync -chavzP --stats user@remote:~/path
abbr -a yt-audio "youtube-dl -f \"bestaudio\" -o \" %(title)s.%(ext)s\" --user-agent \"Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)\""
abbr -a yt-video "youtube-dl -f \"bestvideo+bestaudio\" -o \" %(title)s.%(ext)s\" --user-agent \"Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)\""
function borgstatus
    echo (/usr/bin/ls -lt *.log | head -n 1 | rev | cut -d ' ' -f 1 | rev)
    grep 'status, ' (/usr/bin/ls -lt *.log | head -n 1 | rev | cut -d ' ' -f 1 | rev)
end

function fix_perms
    find . -type f -exec chmod 644 '{}' \;
    find . -type d -exec chmod 775 '{}' \;
end

function rename
    set tmp (mktemp)
    echo $argv > $tmp
    vim $tmp
    mv $argv (cat $tmp | head -n 1)
    rm -f $tmp
end

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

## t480 specific
set -gx TERMINFO /lib/terminfo
xset r rate 250 60
# Fix settings on trackpoint for ideal sensitivity, enable natural scrolling on touchpad
function tp
    xinput set-prop "TPPS/2 IBM TrackPoint" "libinput Accel Speed" 1;
    xinput set-prop "Synaptics TM3276-022" "libinput Natural Scrolling Enabled" 1
    xinput set-prop "Synaptics TM3276-022" "libinput Accel Speed" 0.5
    echo 255 | sudo tee /sys/devices/platform/i8042/serio1/driver/serio2/sensitivity
    echo 200 | sudo tee /sys/devices/platform/i8042/serio1/driver/serio2/speed
end
alias touchpad_on 'xinput set-prop "Synaptics TM3276-022" "Device Enabled" 1'
alias touchpad_off 'xinput set-prop "Synaptics TM3276-022" "Device Enabled" 0'
alias hdmi_left 'xrandr --output eDP-1 --auto --output HDMI-2 --auto --primary --left-of eDP-1'
alias hdmi_right 'xrandr --output eDP-1 --auto --output HDMI-2 --auto --primary --right-of eDP-1'
alias hdmi_above 'xrandr --output eDP-1 --auto --output HDMI-2 --auto --primary --above eDP-1'
alias hdmi_dup 'xrandr --output eDP-1 --auto --output HDMI-2 --auto --same-as eDP-1'
alias hdmi_off 'xrandr --output HDMI-2 --off'
alias dp_left 'xrandr --output eDP-1 --auto --output DP-1 --auto --primary --left-of eDP-1'
alias dp_right 'xrandr --output eDP-1 --auto --output DP-1 --auto --primary --right-of eDP-1'
alias dp_left_scale 'xrandr --fb 6400x2400 --output eDP-1 --mode 2560x1440 --pos 3840x0 --output DP-1 --primary --mode 1920x1200 --pos 0x0 --scale 1.2x1.2 --filter bilinear'
alias dp_right_scale 'xrandr --fb 5824x2400 --output eDP-1 --mode 2560x1440 --pos 0x0 --output DP-1 --primary --mode 1920x1200 --pos 3072x0 --scale 1.3x1.3 --filter bilinear'
alias dp_right_scale2 'xrandr --fb 6720x4000 --output eDP-1 --mode 2560x1440 --pos 0x0 --output DP-1 --primary --mode 1920x1200 --pos 3840x0 --scale 1.5x1.5'
alias dp_off 'xrandr --output DP-1 --off'
alias nvidia_auto 'echo auto | sudo tee /sys/bus/pci/devices/0000:01:00.0/power/control'
function ext_brightness
    ddcutil setvcp --model "DELL U2515HX" 0x10 $argv > /dev/null 2>&1
end
alias dropdown 'silent alacritty --class dropdown'
alias dropdown_arith 'silent alacritty --class arithmetic -e /usr/bin/python'

## VNC
function vnc
    vncserver -geometry 2560x1440 2>&1 | grep ^New | awk '{print \$6;}' | tee .vivnc2 | awk -F: '{print \$1\":\"5900+\$2\" `whoami`@\"\$1}' > .vivnc2
end
alias vncnum 'ps -fu `whoami` | grep -i vnc | head -n1 | awk '"'"'{print $9;}'"'"
alias vnckill "cat ~/.vivnc2 | xargs vncserver -kill"
alias bwrcvnc 'ssh -L 5901:`ssh vighnesh.iyer@bwrcrdsl-2.eecs.berkeley.edu "cat ~/.vivnc2"`'
alias bwrctunnel 'sshuttle -vvvv -r cs199-ban@eda-1.eecs.berkeley.edu 0/0 -x eda-1.eecs.berkeley.edu'

## SSH Aliases
#alias ssh_intovps='ssh 184.75.242.173 -l www -p 33322 -i ~/Documents/sync/WEBSITES/Servers_Credentials/IntoVPS/SSH/id_www'
alias ssh_ramnode 'ssh -i ~/.ssh/ramnode_id_rsa vighnesh@23.226.231.82'
alias ssh_hpse 'ssh hpse-11.eecs.berkeley.edu -l cs199-ban -Y'
alias ssh_eda 'ssh eda-1.eecs.berkeley.edu -l cs199-ban -Y'
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
alias records='silent libreoffice /home/vighnesh/90-notes/personal/Records.ods'
alias log='silent libreoffice /home/vighnesh/90-notes/maxxing/Log.ods'
alias tl 'pdf /home/vighnesh/30-references/31-engineering/specs/tilelink-spec-1.8.0.pdf'

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

alias mount_exfat 'sudo mount -t exfat /dev/sdb1 /mnt/usb -o rw,uid=(id -u),gid=(id -g)'
alias mount_vfat 'sudo mount -t vfat /dev/sdb1 /mnt/usb -o rw,uid=(id -u),gid=(id -g)'

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
    sshfs -o allow_other,uid=1000,gid=1000,IdentityFile=/home/vighnesh/.ssh/id_rsa cs199-ban@eda-1.eecs.berkeley.edu:/scratch/cs199-ban /mnt/eda
end

function unmount_eda
    if mount | grep /mnt/eda > /dev/null;
        fusermount -u /mnt/eda
    end
end

# PATH manipulation
set -gx RISCV /opt/riscv-gcc-10-sifive
set -gx LD_LIBRARY_PATH \
    $RISCV/lib \
    /usr/local/lib
set -gx PATH \
    $RISCV/bin \
    #/opt/miniconda/bin \
    /home/vighnesh/.bin \
    /home/vighnesh/.local/bin \
    /usr/local/sbin \
    /usr/local/bin \
    /usr/bin \
    /usr/bin/site_perl \
    /usr/bin/vendor_perl \
    /usr/bin/core_perl \
    $HOME/.local/share/coursier/bin \
    /opt/vivado/Vivado/2021.1/bin \
    #/home/vighnesh/20-research/23-projects/17-formal/symbiotic_intro_course/bin

#set -gx SYMBIOTIC_LICENSE /home/vighnesh/20-research/23-projects/17-formal/symbiotic_intro_course/symbiotic.lic
#source /opt/miniconda3/etc/fish/conf.d/conda.fish

# This function is called every time Enter is hit when in a terminal
# The working directory is written to a tempfile, which is read by i3 if you want a new terminal with the same working directory
function dostuff --on-event fish_prompt
    pwd > /tmp/whereami
end

# https://www.reddit.com/r/linux/comments/72mfv8/psa_for_firefox_users_set_moz_use_xinput21_to/
# Enable firefox smooth scrolling with trackpad and trackpoint
set -gx MOZ_USE_XINPUT2 1

# HiDPI settings: https://wiki.archlinux.org/title/HiDPI
set -gx QT_AUTO_SCREEN_SCALE_FACTOR 1
