#set -x fish_user_paths $fish_user_paths /usr/local/share/npm/bin
#set -x fish_user_paths $fish_user_paths ~/.lein/bin
#set -x fish_user_paths $fish_user_paths ~/.cabal/bin
set -x fish_user_paths $fish_user_paths /usr/local/opt/coreutils/libexec/gnubin
set -x fish_user_paths $fish_user_paths /usr/local/heroku/bin

set -x EDITOR emacs -Q

set -gx RBENV_ROOT ~/.rbenv
. (rbenv init -|psub)

set -x DOCKER_IP 192.168.59.104
set -x DOCKER_TLS_VERIFY 0
set -x DOCKER_HOST tcp://192.168.59.104:2376
set -x DOCKER_CERT_PATH /Users/jhirn/.boot2docker/certs/boot2docker-vm

source ~/.aliases
