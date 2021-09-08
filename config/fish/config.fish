eval (/opt/homebrew/bin/brew shellenv)

# Outdated as of m1
# set -g fish_user_paths /usr/local/bin $fish_user_paths
# set -g fish_user_paths "/usr/local/opt/libxml2/bin" $fish_user_paths
set -x EDITOR "emacs -Q"

set -X BREW_PREFIX (brew --prefix)

set -x ASDF_DIR /opt/homebrew/opt/asdf #(brew --prefix asdf)
source /opt/homebrew/opt/asdf/libexec/asdf.fish

if test -d $BREW_PREFIX/share/fish/vendor_completions.d
  echo "completions"
  set -gx fish_complete_path $fish_complete_path $BREW_PREFIX/share/fish/vendor_completions.d
end

set -x fish_user_paths $fish_user_paths /usr/local/sbin
# Potentially outdated as of m1 (was for obscure image magick)
# set -gx PKG_CONFIG_PATH /usr/local/lib/pkgconfig

# set -gx RUBY_CONFIGURE_OPTS --with-openssl-dir=/usr/local/opt/openssl@1.1 #(brew --prefix openssl@3.1)

# set -x JAVA_HOME /Library/Java/JavaVirtualMachines/openjdk-13.0.2.jdk/Contents/Home
# (/usr/libexec/java_home -v 13)

source ~/.aliases

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
