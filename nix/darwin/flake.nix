{
  description = "Jhirn's darwin flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    system = "aarch64-darwin";
    lib = nixpkgs.lib;
  in
  {
    darwinConfigurations.mbp = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        ./configuration.nix
        home-manager.darwinModules.home-manager
        {
           home-manager.users.jhirn = {
            home.username = "jhirn";
            home.homeDirectory = "/Users/jhirn";
            home.stateVersion = "24.05";

            imports = [ ./home.nix ];
          };
        }
      ];
    };

    darwinPackages = self.darwinConfigurations.mbp.pkgs;
  };
}
