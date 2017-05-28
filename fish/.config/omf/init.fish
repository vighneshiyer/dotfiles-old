set -g theme_color_scheme solarized
set -g theme_display_git no 
set -g theme_display_git_untracked no
set -g theme_display_git_ahead_verbose no
set -g theme_git_worktree_support yes
set -g default_user root
set -g theme_display_user yes

function rsync_eecs151
    rsync -rtuvPa eecs151-tab@c125m-13.eecs.berkeley.edu:~/class/ ~/eecs151_rsync/
    rsync -rtuvPa ~/eecs151_rsync/ eecs151-tab@c125m-13.eecs.berkeley.edu:~/class/
end

function rsync_ee241b
    rsync -rtuvPa cs199-ban@hpse-11.eecs.berkeley.edu:~/class/ ~/ee241b_rsync/
    rsync -rtuvPa ~/ee241b_rsync/ cs199-ban@hpse-11.eecs.berkeley.edu:~/class/
end

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
alias rca 'vim ~/.config/omf/fish.init'
alias vi 'vim'
alias c 'clear'

## git
alias gitdiff 'git difftool --tool=vimdiff --no-prompt'
alias gs 'git status'
alias gsu 'git status -uno'
alias gpull 'git pull'
alias gfetch 'git fetch'
alias gpush 'git push'

# Used for Xorg forwarding
#set -xg DISPLAY 0.0

# For launching (usually graphical) applications that produce lots of junk printed out
function silent 
    nohup $argv </dev/null >/dev/null 2>&1 &
end

# SSH to various servers
alias ssh_ramnode 'ssh vighnesh@23.226.231.82'
alias ssh_ee241b 'ssh hpse-11.eecs.berkeley.edu -l cs199-ban -Y'
alias ssh_eecs151 'ssh c125m-15.eecs.berkeley.edu -l eecs151-tab -Y'
alias ssh_bwrc 'ssh bwrcrdsl-2.eecs.berkeley.edu -l vighnesh.iyer -Y'
alias ssh_dp690 'ssh dp690-12.eecs.berkeley.edu -l vighnesh.iyer -Y'

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

