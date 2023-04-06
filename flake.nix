{
  description = "Usher Systems Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = github:msteen/nixos-vscode-server;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = github:ryantm/agenix;
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      mkSystem = (import ./utils/mkSystem.nix);
    in
    {
      channelsConfig.allowUnfree = true;

      nixosConfigurations.crwban = mkSystem {
        inherit inputs nixpkgs;
        hostname = "crwban";
        system = "x86_64-linux";
        users = {
          tom = {
            nixos = ./users/tom/user.nix;
            home-manager = [ ./users/tom/remote.nix ./users/tom/email.nix ];
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
            home-manager = [ ./users/tom/guest-vm.nix ];
          };
        };
      };
    };
}
