#!/bin/bash
if [ $(id -u) != 0 ]; then
   echo "This script requires root permissions"
   sudo -v
fi

# Windows <-> Linux clipboard support
if ! type -a lemonade &> /dev/null; then
   mkdir ~/lemonade_tmp
   wget -P ~/lemonade_tmp/ -q https://github.com/pocke/lemonade/releases/download/v1.1.1/lemonade_linux_amd64.tar.gz
   tar xzf ~/lemonade_tmp/lemonade_linux_amd64.tar.gz -C ~/lemonade_tmp/
   sudo cp ~/lemonade_tmp/lemonade /usr/local/bin
   rm -rf ~/lemonade_tmp/
fi

# Tmux
sudo pacman -S tmux --noconfirm

# Neovim + plugins
sudo pacman -S neovim --noconfirm
sudo pacman -S python2-neovim python-neovim --noconfirm
yaourt -S ruby-neovim --noconfirm

# Zsh + Antigen
sudo pacman -S zsh --noconfirm
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
chmod -R 755 ~/.zplug

# Gnu Stow
sudo pacman -S stow --noconfirm

# Restore dotfiles
stow tmux nvim zsh

nvim --headless +PlugInstall +qall
nvim --headless +UpdateRemotePlugins +qall

#
# Development stuff
#

# Redis
sudo pacman -S redis --noconfirm
sudo systemctl start redis
sudo systemctl enable redis

# Qt/QtWebKit
sudo pacman -S qt5-base qt5-webkit --noconfirm

# Node/npm
sudo pacman -S nodejs npm --noconfirm

# Postgresql
sudo pacman -S postgresql --noconfirm

sudo systemctl start postgresql
sudo systemctl enable postgresql

export $HOMEUSER=$USER # Preserve current username
sudo -Eu postgres initdb --locale $LANG -E UTF8 -D '/var/lib/postgres/data'
sudo -Eu postgres createuser $HOMEUSER --superuser

# Asdf version manager
git clone https://github.com/asdf-vm/asdf.git "${HOME}/.asdf" --branch v0.3.0
source ~/.asdf/asdf.sh

# Ruby
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby 2.4.0
asdf global ruby 2.4.0

zsh -c "gem install bundler"
zsh -c "gem install foreman"
zsh -c "gem install rails -v 5.0.1"

# Elixir
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git

asdf install erlang 20.0
asdf global erlang 20.0

asdf install elixir 1.5.0
asdf global elixir 1.5.0

zsh -c "mix local.hex --force"
zsh -c "mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez --force"

