#!/bin/bash

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y ruby git build-essential zlib1g-dev libreadline-dev libssl-dev libcurl4-openssl-dev emacs-snapshot-el emacs-snapshot-gtk emacs-snapshot ack-grep

#ack is the only ack that matters
sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep
