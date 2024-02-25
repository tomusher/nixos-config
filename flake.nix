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
    vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv.url = github:cachix/devenv/latest;
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      mkSystem = (import ./utils/mkSystem.nix);
    in
    {
      channelsConfig.allowUnfree = true;

      nixosConfigurations.afanc = mkSystem.nixos {
        inherit inputs nixpkgs;
        hostname = "afanc";
        system = "x86_64-linux";
      };

      nixosConfigurations.crwban = mkSystem.nixos {
        inherit inputs nixpkgs;
        hostname = "crwban";
        system = "x86_64-linux";
      };

      nixosConfigurations.ystlum = mkSystem.nixos {
        inherit inputs;
        hostname = "ystlum";
        system = "aarch64-linux";
        sshPubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFRmRghei+y/qUgEUhMrqtXbI+tqtTDdPIjvV6QiyQUd";
      };

      darwinConfigurations.llwynog = mkSystem.darwin {
        inherit inputs;
        hostname = "llwynog";
        system = "aarch64-darwin";
      };
    };
}
