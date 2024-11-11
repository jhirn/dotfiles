{ config, pkgs, ... }: {
  # Let home-manager manage itself
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Add your user packages here
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      test -e ~/.aliases ; and source ~/.aliases
    '';
  };

  # Add your dotfiles
  home.file = {
    ".aliases".source = ../../dotfiles/.aliases;
    ".config/fish/config.fish".source = ../../dotfiles/.config/fish/config.fish;
  };
}
