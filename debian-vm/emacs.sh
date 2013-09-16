#!/bin/bash

if [ ! -d ~/.emacs.d ]; then
  git clone https://github.com/jhirn/emacs-prelude ~/.emacs.d
fi
EMACS_ICON=${HOME}/.local/share/applications/emacs.png

cp ~/src/dotfiles/debian-vm/icons/emacs.png $EMACS_ICON

cat >  ~/.local/share/applications/emacs.desktop <<EOF
[Desktop Entry]
Version=`emacs --version| head -n 1`
Name=Emacs
Comment=This is my editor
Exec=/usr/bin/emacs
Icon=$EMACS_ICON
Terminal=false
Type=Application
Categories=Utility;Application;Development
EOF

echo "Installed emacs, dotfiles, desktop file for dash and icon"
