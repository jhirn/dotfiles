set -x BREW_PREFIX /opt/homebrew # (brew --prefix)
set -x HOMEBREW_BUNDLE_FILE ~/.Brewfile
set -x EDITOR "code"

set -gx RUBY_CONFIGURE_OPTS --with-openssl-dir=$BREW_PREFIX/opt/openssl@1.1 --with-jemalloc
set -g theme_display_node yes

fish_add_path /usr/local/sbin

eval ($BREW_PREFIX/bin/brew shellenv)

status --is-interactive; and rbenv init - fish | source
test -e ~/.iterm2_shell_integration.fish ; and source ~/.iterm2_shell_integration.fish
test -e ~/.local.fish ; and source ~/.local.fish
test -e ~/.aliases ; and source ~/.aliases

fnm env --use-on-cd | source

# Potentially outdated as of m1 (was for obscure image magick7 bug)
# set -gx PKG_CONFIG_PATH /usr/local/lib/pkgconfig

# Deep competion for aws-cli
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

echo "completed fish profile"
