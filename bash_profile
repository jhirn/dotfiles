#!/bin/bash

#perforce
P4CLIENT=jhirn
P4EDITOR=emacs
P4PORT=depot.iwprint.net:1666

for file in `find ~/.bash_completion.d/*`
do
   . $file
done


if [ `which brew` ] && [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

## Shell
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1='\[\033[01;32m\]\u@\h:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;32m\]$(parse_git_branch)\[\033[00m\] \$ '

##Emacs
export RSENSE_HOME=/.emacs.d/vendor/rsense-0.3
if [ -f ~/.emacs.d/vendor/rsense-0.3/etc/rsense.rb ]; then
    ruby ~/.emacs.d/vendor/rsense-0.3/etc/rsense.rb > ~/.rsense
fi

## RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
[[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion

##Aliases
alias ls='ls -G'
alias ll='ls -l'
alias up='cd ..'
alias ec='emacsclient'
export MAVEN_HOME=/opt/apache-maven-3.0.3
export JAVA_HOME=/usr/lib/jvm/java-6-sun-1.6.0.26
export MAVEN_OPTS="-XX:MaxPermSize=512m"
