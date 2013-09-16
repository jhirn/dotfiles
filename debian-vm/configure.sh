#!/bin/bash

mkdir -p ~/src
if [ ! -d ~/src/dotfiles ]; then
    git clone https://github.com/jhirn/dotfiles ~/src/dotfiles
    ~/src/dotfiles/install.rb
fi

pushd ~/src/dotfiles/debian-vm
./packages.sh
./emacs.sh
./rbenv.sh
popd
