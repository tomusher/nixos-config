{
  description = "Usher Systems Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv.url = github:cachix/devenv/latest;
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      mkSystem = (import ./utils/mkSystem.nix);
    in
    {
      channelsConfig.allowUnfree = true;

      nixosConfigurations.crwban = mkSystem.nixos {
        inherit inputs nixpkgs;
        hostname = "crwban";
        system = "x86_64-linux";
      };

      darwinConfigurations.llwynog = mkSystem.darwin {
        inherit inputs;
        hostname = "llwynog";
        system = "aarch64-darwin";
      };
    };
}
