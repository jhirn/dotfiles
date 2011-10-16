#!/bin/bash

for f in  ;do
  source $file~/.bash_completion.d
done

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1='\[\033[01;32m\]\u@\h:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;32m\]$(parse_git_branch)\[\033[00m\] \$ '

export RSENSE_HOME=/.emacs.d/vendor/rsense-0.3

if [ -f ~/.emacs.d/vendor/rsense-0.3/etc/rsense.rb ]; then
    ruby ~/.emacs.d/vendor/rsense-0.3/etc/rsense.rb > ~/.rsense
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
[[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion

source ~/.aliases
