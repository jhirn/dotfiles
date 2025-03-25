#!/bin/bash

# Alt-tab app switcher on all displays.
defaults write com.apple.dock appswitcher-all-displays -bool true
killall Dock
