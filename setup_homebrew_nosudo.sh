#!/bin/bash
set -e

if ! [ -d "$HOME/homebrew" ]; then
  git clone https://github.com/Homebrew/homebrew.git "$HOME/homebrew"
else
  echo "Homebrew directory already exists."
fi

mkdir -p "$HOME/"{etc,bin,opt,include,lib,share/man/man1,man,Frameworks,homebrew}
ln -fs "$HOME/homebrew/share/man/man1/brew.1" "$HOME/share/man/man1/brew.1"
ln -fs "$HOME/homebrew/bin/brew" "$HOME/bin/brew"
chflags hidden "$HOME/"{etc,opt,include,lib,share,man,Frameworks,homebrew}

echo "brew installed at $(which brew)"
