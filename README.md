# Dotfiles

This repo contains my dotfiles and OS/Distro specific scripts, which will install:
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

Supported setups when using the install script (for now):
- Windows Subsystem for Linux (Tested on the Windows Store version of OpenSUSE LEAP 42.2)
- Hyper-V with Arch Linux

# Running the script

**Make sure you have everything setup correctly, as described below**

The script requires root and will ask for the root password by itself, **don't start the script as root, use your normal user**

```
cd ~
git clone git@github.com:Kuret/dotfiles.git
cd dotfiles
chmod +x install.sh
./install-{distro}.sh
```

# Manually

- Install GNU Stow using you package manager
- Install whatever packages you need
- Use `stow` to symlink the dotfiles

# WSL setup

Requirements before running the script:
- Git

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

# Windows Subsystem For Linux

Activate the WSL in windows:
- Make sure you are running a Windows 10 build with Windows Store support for WSL (build 16215+)
- Open powershell as administrator and run command

   `Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux`
   
- Go to the Windows store and install the package `OpenSUSE Leap` or `Ubuntu` (Did not verify this script on Ubuntu)
- Run the user setup and set your username and passwords

For cross platform copy-paste support I use Lemonade: https://github.com/pocke/lemonade
- The install script installs the Linux client
- Download the Windows application from https://github.com/pocke/lemonade/releases
- Unzip the Windows version and put the `lemonade.exe` in a convenient directory
- To run the server open a command prompt and run `lemonade.exe server`
- To run the server in the background without showing a terminal window create a file `lemonade.vbs` and put in the following
   ```
   Dim WinScriptHost
   Set WinScriptHost = CreateObject("WScript.Shell")
   WinScriptHost.Run("C:\Workspace\Tools\Lemonade\lemonade.exe server"), 0, true
   Set WinScriptHost = Nothing
   ```
- To run this automatically on startup create a registry key in `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run` with the value `WScript C:\Path\To\lemonade.vbs`

- To send something to the clipboard from Linux run `lemonade copy "YourClipboardText"` or `OutputToPipe | lemonade copy`

I recommend running PSQL Portable from Windows: https://github.com/garethflowers/postgresql-portable
For easy cross platform connection in a dev setup:
- Make a superuser with the same username as your linux user
- Make a default database with the same name as your linux user
- In your .bashrc/.zshrc add the following: `export PGHOST=localhost`
- You should be able to connect using just the command `psql` now

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
