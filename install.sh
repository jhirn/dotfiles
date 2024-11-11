#!/bin/bash

# Install nix
bash <(curl -L https://nixos.org/nix/install) --daemon

# Initialize nix-darwin
# mkdir -p ~/.nix/nix-darwin
# pushd ~/.nix/nix-darwin
# nix flake init -t nix-darwin --extra-experimental-features "nix-command flakes"
# sed -i '' "s/simple/$(scutil --get LocalHostName)/" flake.nix
# popd


nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ./nix/darwin#mbp


# darwin-rebuild build --flake ./nix/darwin#mbpa
