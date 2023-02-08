set -x BREW_PREFIX /opt/homebrew # (brew --prefix)
set -x HOMEBREW_BUNDLE_FILE ~/.Brewfile

eval ($BREW_PREFIX/bin/brew shellenv)


status --is-interactive; and rbenv init - fish | source

set -x EDITOR "code"

# if test -d $BREW_PREFIX/share/fish/completions
#     set -gx fish_complete_path $fish_complete_path $BREW_PREFIX/share/fish/completions
# end

# if test -d $BREW_PREFIX/share/fish/vendor_completions.d

#   set -gx fish_complete_path $fish_complete_path $BREW_PREFIX/share/fish/vendor_completions.d
# end



set -x fish_user_paths $fish_user_paths /usr/local/sbin
set -gx RUBY_CONFIGURE_OPTS --with-openssl-dir=$BREW_PREFIX/opt/openssl@1.1 --with-jemalloc

source ~/.aliases

test -e ~/.iterm2_shell_integration.fish ; and source ~/.iterm2_shell_integration.fish

fnm env --use-on-cd | source

# Potentially outdated as of m1 (was for obscure image magick7 bug)
# set -gx PKG_CONFIG_PATH /usr/local/lib/pkgconfig

# Outdated as of m1
# set -g fish_user_paths /usr/local/bin $fish_user_paths
# set -g fish_user_paths "/usr/local/opt/libxml2/bin" $fish_user_paths

fish_add_path /opt/homebrew/opt/openjdk/bin
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

set -g theme_display_node yes
source ~/.local.fish
echo "completed fish profile"
