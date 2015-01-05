#!/bin/bash


export PATH=/usr/local/opt/coreutils/libexec/gnubin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/sbin
export PATH=$PATH:/usr/bin
export PATH=$PATH:/bin
export PATH=$PATH:/usr/sbin
export PATH=$PATH:/sbin
export PATH=$PATH:~/Applications/eb/macosx/python2.7
export PATH=$HOME/.lein/bin:$PATH
export PATH=/usr/local/share/npm/bin:$PATH
export PATH=/usr/local/heroku/bin:$PATH
export PATH=/usr/texbin:$PATH
export PATH=~/.cabal/bin:$PATH
### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"


RBENV_ROOT="$HOME/.rbenv"
if [[ -d $RBENV_ROOT ]]; then
    PATH=$RBENV_ROOT/bin:$PATH
    eval "$(rbenv init - --no-rehash)"
fi

if [[ $(uname -a | grep Darwin) ]]; then
    export JAVA_HOME=$(/usr/libexec/java_home)
    export PATH=$JAVA_HOME/bin:$PATH
fi

#######################################################
#              End of path fuckery                    #
#######################################################

export MAVEN_OPTS="-XX:MaxPermSize=512m"
export EDITOR="emacs"


TMP=`mktemp -t bash_profile.XXXXXX`
trap "rm $TMP* 2>/dev/null" EXIT

eval $(boot2docker shellinit 2> /dev/null)
export DOCKER_IP=192.168.59.103


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

##Aliases
source ~/.aliases

if [ -r ~/.machine_profile ]; then
  source ~/.machine_profile
fi

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
