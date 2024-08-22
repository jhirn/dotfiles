# SHELL things

eval "$(/opt/homebrew/bin/brew shellenv)"
set -x HOMEBREW_BUNDLE_FILE ~/.Brewfile
set -x EDITOR "code"

test -e ~/.iterm2_shell_integration.fish ; and source ~/.iterm2_shell_integration.fish
test -e ~/.aliases ; and source ~/.aliases
test -e ~/.local.fish ; and source ~/.local.fish

# Set up direnv (later)
# direnv hook fish | source
# RUBY Things
status --is-interactive; and rbenv init - fish | source

# fish_add_path -m /Users/jhirn/.rbenv/shims
#set -x RUBY_DEBUG_IRB_CONSOLE "true"
#set -x RUBY_DEBUG_HISTORY_FILE "$HOME/.irb_history"
#set -x RUBY_DEBUG_SAVE_HISTORY 10000
set -x RUBY_DEBUG_FORK_MODE "parent"
set -gx RUBY_CONFIGURE_OPTS "--with-openssl-dir=$HOMEBREW_PREFIX/opt/openssl --enable-yjit --with-readline-dir=$HOMEBREW_PREFIX/opt/readline"


set -g theme_display_node yes

# Javascript things
fnm env --use-on-cd | source
# Potentially outdated as of m1 (was for obscure image magick7 bug)
# set -gx PKG_CONFIG_PATH /usr/local/lib/pkgconfig

# Java things
# fish_add_path /Users/jhirn/.sdkman/candidates/java/current/bin

# Intellij!
#fish_add_path "/Applications/IntelliJ IDEA CE.app/Contents/MacOS"

# Rust things
#fish_add_path -mP $HOME/.cargo/bin

# Deep competion for aws-cli
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

# SSH agent
if not pgrep ssh-agent > /dev/null
    eval (ssh-agent -c)
end
ssh-add ~/.ssh/id_ed25519 > /dev/null 2>&1

# if status is-interactive
#   mise activate fish | source
# else
#   mise activate fish --shims | source
# end

ulimit -n 1024
echo "completed fish profile"
