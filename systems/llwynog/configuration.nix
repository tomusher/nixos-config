{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    inputs.home-manager.darwinModule
  ];

  environment.systemPackages = [
    pkgs.vim
  ];

  users.users.tom = {
    name = "tom";
    home = "/Users/tom";
  };

  programs.zsh.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users.tom = { pkgs, ... }: {
    home.packages = [
      inputs.devenv.packages.${pkgs.stdenv.hostPlatform.system}.devenv
      pkgs.zoom-us
      pkgs.plex-media-player
      pkgs.discord
    ];
    imports = [ ../../users/tom/apps/common.nix ];
  };

  services.nix-daemon.enable = true;

  system.stateVersion = 4;

}

