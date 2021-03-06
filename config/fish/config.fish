set -g fish_user_paths /usr/local/bin $fish_user_paths
#set -g fish_user_paths "/usr/local/opt/libxml2/bin" $fish_user_paths

set -x fish_user_paths $fish_user_paths /usr/local/sbin
set -gx PKG_CONFIG_PATH /usr/local/lib/pkgconfig

set -gx RUBY_CONFIGURE_OPTS --with-openssl-dir=/usr/local/opt/openssl@1.1 #(brew --prefix openssl@1.1)

set -x JAVA_HOME /Library/Java/JavaVirtualMachines/openjdk-13.0.2.jdk/Contents/Home
# (/usr/libexec/java_home -v 13)

set -x EDITOR "emacs -Q"
set -x ASDF_DIR /usr/local/opt/asdf #(brew --prefix asdf)

source ~/.aliases

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
source /usr/local/opt/asdf/asdf.fish

set -g fish_user_paths "/usr/local/opt/postgresql@11/bin" $fish_user_paths
