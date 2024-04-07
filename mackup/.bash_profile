#!/bin/bash

export BREW_PREFIX=/opt/homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# export PATH=$PATH:/usr/bin
# export PATH=$PATH:/bin
# export PATH=$PATH:/usr/sbin
# export PATH=$PATH:/sbin
eval "$(rbenv init - bash)"

# if [[ $(uname -a | grep Darwin) ]]; then
#     export JAVA_HOME=$(/usr/libexec/java_home)
#     export PATH=$JAVA_HOME/bin:$PATH
# fi

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

[[ -r $BREW_PREFIX/etc/profile.d/bash_completion.sh ]] && . $BREW_PREFIX/etc/profile.d/bash_completion.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/jhirn/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/jhirn/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/jhirn/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/jhirn/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/jhirn/.sdkman"
[[ -s "/Users/jhirn/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/jhirn/.sdkman/bin/sdkman-init.sh"
. "$HOME/.cargo/env"
