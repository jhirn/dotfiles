set -x BREW_PREFIX /opt/homebrew # (brew --prefix)
eval ($BREW_PREFIX/bin/brew shellenv)

status --is-interactive; and rbenv init - fish | source

set -x EDITOR "code"

if test -d $BREW_PREFIX/share/fish/vendor_completions.d
  set -gx fish_complete_path $fish_complete_path $BREW_PREFIX/share/fish/vendor_completions.d
end

set -x fish_user_paths $fish_user_paths /usr/local/sbin
set -gx RUBY_CONFIGURE_OPTS --with-openssl-dir=$BREW_PREFIX/opt/openssl@1.1

source ~/.aliases

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

fnm env --use-on-cd | source

# Potentially outdated as of m1 (was for obscure image magick7 bug)
# set -gx PKG_CONFIG_PATH /usr/local/lib/pkgconfig

# Outdated as of m1
# set -g fish_user_paths /usr/local/bin $fish_user_paths
# set -g fish_user_paths "/usr/local/opt/libxml2/bin" $fish_user_paths

# set -x RUBOCOP_DAEMON_USE_BUNDLER true
# fish_add_path -a '/usr/local/bin/rubocop-daemon-wrapper'
# set -x JAVA_HOME /Library/Java/JavaVirtualMachines/openjdk-13.0.2.jdk/Contents/Home
# (/usr/libexec/java_home -v 13)
fish_add_path /opt/homebrew/opt/openjdk/bin
