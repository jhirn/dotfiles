# SHELL things

eval "$(/opt/homebrew/bin/brew shellenv)"
set -x HOMEBREW_BUNDLE_FILE ~/.Brewfile
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

status --is-interactive; and rbenv init - fish | source

set -x RUBY_DEBUG_FORK_MODE "parent"
set -gx RUBY_CONFIGURE_OPTS "--with-openssl-dir=$HOMEBREW_PREFIX/opt/openssl --enable-yjit --with-readline-dir=$HOMEBREW_PREFIX/opt/readline"

set -g theme_display_node yes

fnm env --use-on-cd | source

# Deep competion for aws-cli
# complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

# SSH agent
if not pgrep ssh-agent > /dev/null
    eval (ssh-agent -c)
end
ssh-add ~/.ssh/id_ed25519 > /dev/null 2>&1

set -x ES_JAVA_HOME /opt/homebrew/Cellar/openjdk@17/17.0.12
set -x ES_JAVA_OPTS $ES_JAVA_OPTS -Xms1g -Xmx1g -XX:-MaxFDLimit

if status is-interactive
  mise activate fish | source
else
  mise activate fish --shims | source
end

# Nix
if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
end
# End Nix

# ulimit -n 1024
echo "completed fish profile"
