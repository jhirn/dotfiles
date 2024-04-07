set -x BREW_PREFIX /opt/homebrew # (brew --prefix)
set -x HOMEBREW_BUNDLE_FILE ~/.Brewfile
set -x EDITOR "code"

# Set up direnv
direnv hook fish | source

# RUBY Things
set -x RUBY_DEBUG_IRB_CONSOLE "true"
set -x RUBY_DEBUG_FORK_MODE "parent"
set -gx RUBY_CONFIGURE_OPTS "--with-openssl-dir=$BREW_PREFIX/etc/openssl@3 --enable-yjit"
status --is-interactive; and rbenv init - fish | source

set -g theme_display_node yes

fish_add_path /usr/local/sbin

eval ($BREW_PREFIX/bin/brew shellenv)


test -e ~/.iterm2_shell_integration.fish ; and source ~/.iterm2_shell_integration.fish
test -e ~/.local.fish ; and source ~/.local.fish
test -e ~/.aliases ; and source ~/.aliases

fnm env --use-on-cd | source # fast node manager switching.
# Potentially outdated as of m1 (was for obscure image magick7 bug)
# set -gx PKG_CONFIG_PATH /usr/local/lib/pkgconfig

# SDKMAN!
fish_add_path -m /Users/jhirn/.sdkman/candidates/java/current/bin

# Intellij!
fish_add_path "/Applications/IntelliJ IDEA CE.app/Contents/MacOS"

set -U fish_user_paths $HOME/.cargo/bin $fish_user_paths

# Deep competion for aws-cli
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

echo "completed fish profile"
