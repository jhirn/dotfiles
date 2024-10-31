# Install Nix
```shell
bash -c 'bash <(curl -L https://nixos.org/nix/install) --daemon'
```



# Fish shell confilcts

```
❯ dscl . -read /Users/jhirn UserShell
UserShell: /opt/homebrew/bin/fish

~/nix-darwin-config on ☁️  (eu-central-1)
❯ sudo dscl . -create /Users/jhirn UserShell /run/current-system/sw/bin/fish

~/nix-darwin-config on ☁️  (eu-central-1)
❯ dscl . -read /Users/jhirn UserShell
UserShell: /run/current-system/sw/bin/fish
``
