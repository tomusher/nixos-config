{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    inputs.home-manager.darwinModule
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
    ];
    imports = [ ../../users/tom/apps/common.nix ];
  };

  homebrew = {
    enable = true;
    casks = [
      "1password"
      "brave-browser"
      "cutbox"
      "discord"
      "docker"
      "firefox"
      "notion"
      "microsoft-teams"
      "obs"
      "parsec"
      "rectangle"
      "slack"
      "steam"
      "tableplus"
      "zoom"
      "vmware-fusion-tech-preview"
    ];
  };

  services.nix-daemon.enable = true;

  system.stateVersion = 4;

}

