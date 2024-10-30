#!/bin/bash


#Ruby
mkdir -p ~/src/ruby

if [ ! -d ~/src/ruby/rbenv-installer ]; then
    git clone https://github.com/fesplugas/rbenv-installer ~/src/ruby/rbenv-installer
fi

chmod +x ~/src/ruby/rbenv-installer/bin
~/src/ruby/rbenv-installer/bin/rbenv-installer

if [ ! -d ~/.rbenv/plugins/rbenv-binstubs ]; then
    git clone https://github.com/ianheggie/rbenv-binstubs ~/.rbenv/plugins/rbenv-binstubs
fi
PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init - --no-rehash)"
rbenv install 2.0.0-p247 


