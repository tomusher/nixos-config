{
  description = "Usher Systems Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-vscode-server = {
      url = github:MatthewCash/nixos-vscode-server;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = github:ryantm/agenix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv = {
      url = github:cachix/devenv/latest;
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      mkSystem = (import ./utils/mkSystem.nix);
    in
    {
      channelsConfig.allowUnfree = true;

      nixosConfigurations.afanc = mkSystem {
        inherit inputs nixpkgs;
        hostname = "afanc";
        system = "x86_64-linux";
        users = {
          tom = {
            nixos = ./users/tom/user.nix;
            home-manager = ./users/tom/workstation.nix;
          };
        };
      };

      nixosConfigurations.crwban = mkSystem {
        inherit inputs nixpkgs;
        hostname = "crwban";
        system = "x86_64-linux";
        users = {
          tom = {
            nixos = ./users/tom/user.nix;
            home-manager = ./users/tom/remote.nix;
          };
        };
      };

      nixosConfigurations.ystlum = mkSystem {
        inherit inputs nixpkgs;
        hostname = "ystlum";
        system = "aarch64-linux";
        sshPubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFRmRghei+y/qUgEUhMrqtXbI+tqtTDdPIjvV6QiyQUd";
        users = {
          tom = {
            nixos = ./users/tom/user.nix;
            home-manager = ./users/tom/guest-vm.nix;
          };
        };
      };
    };
}
