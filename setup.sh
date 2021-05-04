#!/usr/bin/env bash
# i3
rm ~/.config/i3/config
stow -t ~ i3
# termite
stow -t ~ termite
git clone git@github.com:Corwind/termite-install
cd termite-install && ./termite_install.sh
# Install termite terminfo (to avoid the "unknown terminal type xterm-xtermite warnings")
git clone git@github.com:thestinger/termite
cd termite
tic -x termite.terminfo
# fonts (Source Code Pro)
cd /tmp/
wget https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.zip
unzip 1.050R-it.zip
sudo cp source-code-pro-2.030R-ro-1.050R-it/OTF/*.otf /usr/local/share/fonts/.
fc-cache -f -v
# Neovim
stow -t ~ nvim
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim
sudo apt-get install python-dev python-pip python3-dev python3-pip
# Neovim (vim-plug)
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# now manually nvim and :PlugInstall
# fish
sudo apt-get install fish
curl -L https://get.oh-my.fish | fish
rm ~/.config/omf/bundle
rm ~/.config/omf/channel
rm ~/.config/omf/theme
rm ~/.config/fish/config.fish
stow -t ~ fish
# tmux
stow -t ~ tmux
# Switch shell to fish
chsh
