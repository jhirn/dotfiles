#!/bin/bash

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install ruby git

mkdir -p ~/src

if [ ! -d ~/src/dotfiles ]; then
  git clone https://github.com/jhirn/dotfiles ~/src/dotfiles
  ~/src/dotfiles/install.rb
fi

bash -l


 




