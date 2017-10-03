# Setting up a Fresh Install

To do most of these things, I need my password manager. Install Dropbox, then 1Password, then continue.

First, `git config --global credential.useHttpPath` to make sure the right remote URL gets cached when we clone.

Next, clone into `$HOME`: `git clone https://github.com/joseph-long/dotfiles.git`. 

(Note that unless git's `credential.useHttpPath` is already `true`, you will have to [remove the cached credentials](https://stackoverflow.com/questions/11067818/how-do-you-reset-the-stored-credentials-in-git-credential-osxkeychain). (The `.gitconfig` file in here sets `useHttpPath=true`.) On Linux, [more setup is required](http://blog.iqandreas.com/git/storing-https-authentication-in-ubuntu-and-arch-linux/#storing-your-https-credentials-using-a-keyring) for credential storage.)

Next, link dotfiles into place (after removing the temporary git config): `rm -f ~/.gitconfig && ./setup_dotfiles.sh`

### macOS

To set up `nix-darwin`, `curl https://nixos.org/nix/install > nix-install.sh` and `sh nix-install.sh`. 

Following http://zzamboni.org/post/using-nixs-single-user-mode-on-macos/, convert the installation to single-user:

```
sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist 
sudo launchctl stop org.nixos.nix-daemon
sudo chown -R $USER /nix
```

Edit `/etc/bashrc` and `/etc/profile` and append `unset NIX_REMOTE`.

Remove from /etc/nix/nix.conf:

```
build-users-group = nixbld
```

Then, install from https://github.com/LnL7/nix-darwin (using manual install for now).

```
git clone https://www.github.com/LnL7/nix-darwin.git ~/.nix-defexpr/darwin
mkdir -p ~/.nixpkgs
cp ~/.nix-defexpr/darwin/modules/examples/simple.nix ~/.nixpkgs/darwin-configuration.nix
``` 

The line `if test -e /etc/static/bashrc; then . /etc/static/bashrc; fi` is in `.bash_profile` already, so you don't need to modify it. 

The `/etc/bashrc` and `/etc/nix/nix.conf` created by the Nix installer won't be overwritten by `nix-darwin`, so remove them and open a new terminal to run `darwin-rebuild`.

The nix-darwin installer places a configuration file in `~/.nixpkgs/darwin-configuration.nix`. TODO: copy one from this repo.

Some stateful things need setting:

  * If you have root on the machine: `bash ./setup_osx.sh`
  * If you don't have root on the machine: `bash ./setup_osx_nosudo.sh`

### Linux / other *nix

  * If you just want to copy the dotfiles: `bash ./setup_dotfiles.sh`

Then proceed to download and install those things that require interactive installation.

## Regular Maintenance

Keep Python packages up to date with

```
pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U
```

### macOS

Keep Homebrew-managed applications up to date with `brew update && brew upgrade` (`brew update && brew outdated` to list)

## Cross-platform apps

  - Install [VSCode](https://code.visualstudio.com)
  - Install [Dropbox](https://dropbox.com/)

## macOS App Store & Downloadable DMGs

Set preferences to allow unknown apps: *System Preferences -> Security & Privacy -> General -> Allow apps downloaded from anywhere*

  - Install [1Password](https://1password.com/)
  - Install [XCode from the App Store](https://developer.apple.com/xcode/downloads/)
  - Install [Slate](https://github.com/jigish/slate)
  - Install [The Unarchiver from the App Store](https://itunes.apple.com/app/the-unarchiver/id425424353)
  - Install [Skim](http://skim-app.sourceforge.net)
  - Install [BasicTeX](https://tug.org/mactex/morepackages.html)
  - Install [VLC](https://videolan.org)
  - Install [AppZapper](https://appzapper.com) (don't allow contacts)
  - Install [f.lux](https://justgetflux.com)
  - Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
  - Install [iTerm 2](https://iterm2.com/downloads.html)
  - Install [uBlock](https://www.ublock.org) Safari Extension
  - Install [Processing](https://processing.org)

## Homebrew / Python Apps

  - Install Homebrew

        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

  - Install Python 2.7, Python 3 from Homebrew (`brew install python python3`) and update setuptools

        pip install --upgrade pip setuptools
        pip3 install --upgrade pip setuptools wheel

  - Install Git (`brew install git`)
  - Install mosh (`brew install mobile-shell`)
  - Install FreeType (`brew install freetype`)
  - Install ZeroMQ (`brew install zeromq`)
  - Install `bash_completion` (`brew install bash-completion`)
  - Install some useful Python packages:

        pip install -Ur ~/dotfiles/systemwide_requirements.txt
        pip3 install -Ur ~/dotfiles/systemwide_requirements.txt

  - Install MacTeX (`brew cask install mactex`)
