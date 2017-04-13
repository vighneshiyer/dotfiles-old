# Create a SSH tunnel to local port 5901 from remote port 5901 (which binds to VNC server)
function vnc_tunnel {
	cd ~
	ssh -S vnc-tunnel-socket -O exit bwrcrdsl-2.eecs.berkeley.edu
	ssh -f -N -M -S vnc-tunnel-socket -l vighnesh.iyer -L 5901:bwrcrdsl-2.eecs.berkeley.edu:5901 bwrcrdsl-2.eecs.berkeley.edu 
}

function vnc_tunnel_close {
	cd ~
	ssh -S vnc-tunnel-socket -O exit bwrcrdsl-2.eecs.berkeley.edu
}

function mount_bwrc {
	cd ~
	sudo umount /home/vighnesh/bwrcrdsl-2
	sshfs -o allow_other,uid=1000,gid=1000,IdentityFile=/home/vighnesh/.ssh/id_rsa vighnesh.iyer@bwrcrdsl-2.eecs.berkeley.edu:/tools/projects/vighneshiyer/ ~/bwrcrdsl-2
	cd ~/bwrcrdsl-2
}

function unmount_bwrc {
	sudo umount /home/vighnesh/bwrcrdsl-2
}

function mount_eecs151 {
	cd ~
	sudo umount /home/vighnesh/eecs151
	sshfs -o allow_other,uid=1000,gid=1000,IdentityFile=/home/vighnesh/.ssh/id_rsa eecs151-tab@c125m-15.eecs.berkeley.edu:/home/cc/eecs151/sp17/staff/eecs151-tab ~/eecs151
	cd ~/eecs151
}

function unmount_eecs151 {
	sudo umount /home/vighnesh/eecs151
}

# alias vim to nvim
alias vim='nvim'

# cd aliases on local machine
alias e_books='cd /media/sf_sync/E-Books/'
alias college='cd /media/sf_sync/College/'
alias websites='cd /media/sf_sync/WEBSITES'

alias astro7b='cd /media/sf_sync/College/Berkeley_Spring_2017/Astro_7B'
alias eecs151='cd /media/sf_sync/College/Berkeley_Spring_2017/EECS_151'
alias ee241b='cd /media/sf_sync/College/Berkeley_Spring_2017/EE_241B'
alias ee123='cd /media/sf_sync/College/Berkeley_Spring_2017/EE_123'

# repair wallpaper when changing monitors/resolutions
alias wallpaper='feh --bg-center /media/sf_sync/College/Wallpapers/fascist_league.png'
