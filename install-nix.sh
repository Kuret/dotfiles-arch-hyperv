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

# Nix package manager
if ! type -a nix-env &> /dev/null; then
   sudo mkdir /nix
   sudo chown -R ${USER}:$(id -gn $USER) /nix
   curl https://nixos.org/nix/install | sh
   source ~/.nix-profile/etc/profile.d/nix.sh
fi

# Fix locale errors
nix-env -iA nixpkgs.glibcLocales
export LC_ALL="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LOCALE_ARCHIVE="$(readlink ~/.nix-profile/lib/locale)/locale-archive"

# Git
nix-env -i git

# Tmux
nix-env -i tmux

# Neovim + plugins
nix-env -iA nixpkgs.neovim nixpkgs.python27Packages.neovim nixpkgs.python36Packages.neovim

# Zsh + Zplug
nix-env -i zsh
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
chmod -R 755 ~/.zplug

# Gnu Stow
nix-env -i stow

# Restore dotfiles
stow tmux nvim zsh

nvim --headless +UpdateRemotePlugins +qall
nvim --headless +PlugInstall +qall

#
# Development stuff
#

# Redis/Node/Psql
nix-env -i redis nodejs postgresql

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
