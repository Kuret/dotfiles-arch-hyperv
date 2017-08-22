# Dotfiles

This repo contains my dotfiles and an install script for Arch Linux, which will install:
- Git
- Tmux
- Neovim + Plugins
- Zsh + Zplug
- Stow (to symlink dotfiles)
- Redis
- Nodejs
- PostgreSQL
- Ruby
- Ruby gems: Bundler + Foreman + Rails 5.0.1
- Elixir + Phoenix

# Running the script

**Make sure you have everything setup correctly, as described below**

The script requires root and will ask for the root password by itself, **don't start the script as root, use your normal user**

```
cd ~
git clone git@github.com:Kuret/dotfiles-arch-hyperv.git
cd dotfiles-arch-hyperv
chmod +x install.sh
./install-arch.sh
```

# Manually

- Install GNU Stow using you package manager
- Install whatever packages you need
- Use `stow` to symlink the dotfiles

# Arch setup

Requirements before running the script:
- Locale set (LANG, LANGUAGE, LC_ALL, etc)
- Git
- Yaourt

# Permissions

**This isn't needed if you already have a user you can `sudo` with**

- Add your user to the 'wheel' group

   `sudo usermod -G wheel USERNAME`
   
- Uncomment the relevant line in your sudoers file

   `%wheel  ALL=(ALL) ALL`
   
   Or with NOPASSWD if you don't want to require a password
   
   `%wheel  ALL=(ALL) NOPASSWD: ALL`

# Hyper-V

When running Arch in Hyper-V, following steps are needed to SHH into it properly:
- In Hyper-V create a Virtual Switch -> External switch bound to internet-connected network adapter on host
- Install Arch as normal
- Install required packages

   `sudo pacman -S openssh samba`

- Edit samba config to SSH by hostname

  `sudo nano /etc/samba/smb.conf`

  Add/edit the following lines

    ```
    workgroup = WORKGROUP
    netbios name = <your-host-name>
    ```
- Enable and start services

  ```
  systemctl enable sshd
  systemctl start sshd
  systemctl enable smbd.service
  systemctl start smbd.service
  systemctl enable nmbd.service
  systemctl start nmbd.service
  ```
  
- Edit/uncomment sections in `/etc/ssh/sshd_config`
  
  ```
  PubkeyAuthentication yes
  RSAAuthentication yes
  ```
  
- Cygwin

   Install Cygwin + openssh

  In cygwin: `ssh -t rsa`
  
  Copy the `id_rsa.pub` content to the Arch's .ssh/authorized_keys
  
# Git config

  ```
  git config --global color.ui true
  git config --global user.name "GITHUB USERNAME"
  git config --global user.email "GITHUB EMAIL"
  ssh-keygen -t rsa -b 4096 -C "GITHUB EMAIL"
  ```
  
  `cat ~/.ssh/id_rsa.pub`, paste key into Github account > SSH Keys
  
  `ssh -T git@github.com` to verify ssh connection
