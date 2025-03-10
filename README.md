# Dotfiles

This repository contains my dotfiles managed with GNU Stow.

## Setup

The global configuration in `~/.stowrc` is set to:
```
--dir=/Users/jhirn/src/dotfiles
--target=/Users/jhirn
```

This means that:
- Stow will look for packages in `/Users/jhirn/src/dotfiles`
- Stow will create symlinks in `/Users/jhirn` (home directory)

## Directory Structure

Dotfiles are organized in the `home/` directory. For example:
```
dotfiles/
├── home/
│   ├── bash/
│   │   ├── .bashrc
│   │   └── .bash_profile
│   ├── vim/
│   │   └── .vimrc
│   └── git/
│       └── .gitconfig
```

## Usage

To stow all packages:
```
cd /Users/jhirn/src/dotfiles
stow home
```

To stow a specific package (if you organize by application):
```
cd /Users/jhirn/src/dotfiles
stow -d home bash
```

## Adding New Dotfiles

1. Create the appropriate directory structure in `home/`
2. Move your dotfile from `~` to the corresponding location in `home/`
3. Run `stow home` to create the symlinks

## Removing Symlinks

To remove all symlinks:
```
cd /Users/jhirn/src/dotfiles
stow -D home
```

To remove symlinks for a specific package:
```
cd /Users/jhirn/src/dotfiles
stow -D -d home bash
```
