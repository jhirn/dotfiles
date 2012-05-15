#!/bin/bash

export MAVEN_HOME=/opt/apache-maven-3.0.3
export JAVA_HOME=/usr/lib/jvm/java-6-sun-1.6.0.26
export MAVEN_OPTS="-XX:MaxPermSize=512m"

export CLOJURESCRIPT_HOME=~/src/clj/clojurescript

for file in `find ~/.bash_completion.d/*`
do
   . $file
done

if [ `which brew` ] && [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

## Prompt
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1='\[\033[01;32m\]\u@\h:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;32m\]$(parse_git_branch)\[\033[00m\] \$ '

##Emacs
export RSENSE_HOME=/.emacs.d/vendor/rsense-0.3
if [ -f ~/.emacs.d/vendor/rsense-0.3/etc/rsense.rb ]; then
    ruby ~/.emacs.d/vendor/rsense-0.3/etc/rsense.rb > ~/.rsense
fi

##RB.env
if [[ -d "$HOME/.rbenv" ]]; then
    PATH=$HOME/.rbenv/bin:$PATH
    eval "$(rbenv init -)"
fi



PATH=$CLOJURESCRIPT_HOME/bin:$HOME/.lein/bin:$PATH

if [[ $(uname -a | grep Darwin) ]]; then
    PATH=/usr/local/bin:/usr/local/sbin:$PATH
fi

##Aliases
source ~/.aliases

if [ -r ~/.machine_profile ]; then
  source ~/.machine_profile
fi
