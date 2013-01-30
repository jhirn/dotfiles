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

##RB.env
if [[ -d "$HOME/.rbenv" ]]; then
    PATH=$HOME/.rbenv/bin:$PATH
    eval "$(rbenv init - --no-rehash)"
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

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

###functions

function pr {
    local dir="$PWD"

    until [[ -z "$dir" ]]; do
        if [ -d ./.git ]; then
            break
        else
            cd ..
        fi
        dir="${dir%/*}"
    done
}

function tickle {
    if [ -n "$1" ] && [ ! -f "$1" ]; then
        path=$(dirname $1)
        file=$(basename $1)

        [ ! -d "$path" ] && mkdir -p $path
        /usr/bin/touch "$1"
    else
        echo "tickle will mkdir -p and touch the file at the end of the path"
        echo
        echo "Usage:"
        echo "  tickle path/to/filename.ext"
    fi
}

function touch {
    if [ "$1" == "-p" ]; then # fuck with the touch command
        if [ -n "$2" ]; then
            tickle "$2"
        else
            echo "Usage:"
            echo "  touch -p /non/existent/path/to/filename.ext"
        fi
    else # pass through to the real touch command
        /usr/bin/touch "$@"
    fi
}
