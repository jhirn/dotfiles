#!/bin/bash

export USER_BASH_COMPLETION_DIR=~/.bash_completion.d

if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

export RSENSE_HOME=/.emacs.d/vendor/rsense-0.3
if [ -f ~/.emacs.d/vendor/rsense-0.3/etc/rsense.el && ]; then
    ruby /.emacs.d/vendor/rsense-0.3/etc/rsense.el > ~/.rsense
fi



[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
[[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion

export PS1="\[\e[36;1m\]\[\e[32;1m\]\u@\h:\w>\[\e[0m\] "
