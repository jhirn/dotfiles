{ config, pkgs, lib, ... }: {
  environment.systemPackages = [ pkgs.emacs ];
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";
  programs.fish.enable = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  system = {
    stateVersion = 5;
    defaults = {
      NSGlobalDomain = {
        AppleEnableMouseSwipeNavigateWithScrolls = false;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        AppleShowAllExtensions = true;
        AppleShowScrollBars = "Always";
        NSAutomaticSpellingCorrectionEnabled = false;
        "com.apple.trackpad.forceClick" = false;

      };
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = false;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = false;
    };
    # AppleSymbolicHotKeys = {
    #   # Fn key behavior
    #     "164" = {
    #       enabled = 1;
    #       value.parameters = [ 262144 4294705151 ];
    #       value.type = "modifier";
    #     };
    #     # Mission Control move left
    #     "60" = {
    #       enabled = 0;
    #       value.parameters = [ 32 49 262144 ];
    #       value.type = "standard";
    #     };
    #     # Mission Control move right
    #     "61" = {
    #       enabled = 0;
    #       value.parameters = [ 32 49 786432 ];
    #       value.type = "standard";
    #     };
    #     # Switch to Desktop 1
    #     "64" = {
    #       enabled = 0;
    #       value.parameters = [ 32 49 1048576 ];
    #       value.type = "standard";
    #     };
    #     # Switch to Desktop 2
    #     "65" = {
    #       enabled = 0;
    #       value.parameters = [ 32 49 1572864 ];
    #       value.type = "standard";
    #     };
    #   };
    # };
  };
}
