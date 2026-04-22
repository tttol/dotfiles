{
  description = "dotfiles managed by Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      username = builtins.getEnv "USER";
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit username; };
      };

      packages.${system}.claude-code = import ./claude-code.nix {
        inherit pkgs;
        lib = nixpkgs.lib;
      };
    };
}
