# SHELL things

# Fish cheatsheet
# set -U for settings you want to persist across shell restarts (universal)
# set -g for session-wide settings (global)
# set -x to set for child processes (external commands)
# set -p prepend to array.
# set -l for local variables (temporary)
# set -q for existance
# fish_add_path instead of manually modifying $path
# fish_add_path -a to append to $path

eval "$(/opt/homebrew/bin/brew shellenv)"
set -x HOMEBREW_BUNDLE_FILE ~/.Brewfile
set -x HOMEBREW_FORBIDDEN_FORMULAE "node ruby yarn docker chromedriver"
set -x HOMEBREW_BUNDLE_NO_VSCODE "1"
set -x EDITOR "cursor"

if test -d (brew --prefix)"/share/fish/completions"
    set -p fish_complete_path (brew --prefix)/share/fish/completions
end

if test -d (brew --prefix)"/share/fish/vendor_completions.d"
    set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
end

test -e ~/.iterm2_shell_integration.fish ; and source ~/.iterm2_shell_integration.fish
test -e ~/.aliases ; and source ~/.aliases
test -e ~/.local.fish ; and source ~/.local.fish

# Ruby
# status --is-interactive; and rbenv init - fish | source
set -x RUBY_DEBUG_FORK_MODE "parent"
set -gx RUBY_CONFIGURE_OPTS "--with-openssl-dir=$HOMEBREW_PREFIX/opt/openssl --enable-yjit --with-readline-dir=$HOMEBREW_PREFIX/opt/readline"

# Javascript
fnm env --use-on-cd | source

# Deep competion for aws-cli, not using AWS rn thankfully
# complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

# SSH
if not pgrep ssh-agent > /dev/null
    eval (ssh-agent -c)
end

if test -f ~/.ssh/id_ed25519
  ssh-add ~/.ssh/id_ed25519 > /dev/null 2>&1
end

# Mise
if status is-interactive
  mise activate fish | source
else
  mise activate fish --shims | source
end

# Rust
if test -e /opt/homebrew/opt/rustup/bin
  fish_add_path /opt/homebrew/opt/rustup/bin
end

# Prompting
set -u fish_greeting

if command -qv starship
  starship init fish | source
end

ulimit -n 10240

echo "Fish profile loaded..."
