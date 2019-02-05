set -x fish_user_paths $fish_user_paths /usr/local/sbin

set -x EDITOR "emacs -Q"

set -gx RBENV_ROOT ~/.rbenv
source (rbenv init -|psub)

source ~/.aliases

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
