DOTFILE_PATH="${DOTFILE_PATH:-$HOME/.dotfiles}"

if [[ -d "$HOME/.dotfiles" ]]; then
    pushd $DOTFILE_PATH
    git pull origin master
else
    git clone http://github.com/tobytripp/dotfiles.git $DOTFILE_PATH
    pushd $DOTFILE_PATH
fi

/usr/bin/env ruby install.rb

popd
