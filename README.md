# Setting up a Fresh Install

First, clone into `$HOME`: `git clone https://github.com/joseph-long/dotfiles.git`. Note that unless git's `credential.useHttpPath` is already `true`, you will have to [remove the cached credentials](https://stackoverflow.com/questions/11067818/how-do-you-reset-the-stored-credentials-in-git-credential-osxkeychain). (The `.gitconfig` file in here sets `useHttpPath=true`.) On Linux, [more setup is required](http://blog.iqandreas.com/git/storing-https-authentication-in-ubuntu-and-arch-linux/#storing-your-https-credentials-using-a-keyring) for credential storage.

To get the dotfiles and apply the subset of configuration steps that it was possible to automate, run one of the included scripts:

### macOS

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
