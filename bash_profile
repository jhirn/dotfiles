#!/bin/bash


export PATH=/usr/local/opt/coreutils/libexec/gnubin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/sbin
export PATH=$PATH:/usr/bin
export PATH=$PATH:/bin
export PATH=$PATH:/usr/sbin
export PATH=$PATH:/sbin
export ASDF_DIR=(brew --prefix asdf)

source $(brew --prefix asdf)/asdf.sh

if [[ $(uname -a | grep Darwin) ]]; then
    export JAVA_HOME=$(/usr/libexec/java_home)
    export PATH=$JAVA_HOME/bin:$PATH
fi

#######################################################
#              End of path fuckery                    #
#######################################################

export EDITOR="emacs -Q"

for file in `find ~/.bash_completion.d/*`
do
   . $file
done

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

. $(brew --prefix asdf)/asdf.sh
. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
