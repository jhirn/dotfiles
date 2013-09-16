#!/bin/bash


#Ruby
mkdir -p ~/src/ruby
git clone https://github.com/fesplugas/rbenv-installer ~/src/ruby

chmod +x ~/src/ruby/rbenv-installer/bin
~/src/ruby/rbenv-installer/bin
git clone https://github.com/ianheggie/rbenv-binstubs ~/.rbenv/plugins
bash -l
rbenv install 2.0.0-p247 


