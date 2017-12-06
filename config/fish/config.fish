set -x fish_user_paths $fish_user_paths (brew --prefix qt@5.5)/bin #for capybara https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit#homebrew

set -x fish_user_paths $fish_user_paths /usr/local/heroku/bin
set -x fish_user_paths $fish_user_paths /usr/local/sbin

set -x EDITOR "emacs -Q"

set -gx RBENV_ROOT ~/.rbenv
. (rbenv init -|psub)

source ~/.aliases

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
