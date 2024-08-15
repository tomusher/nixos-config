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
    brews = [
      "mise"
    ];
    casks = [
      "1password"
      "vivaldi"
      "discord"
      "firefox"
      "microsoft-teams"
      "obs"
      "parsec"
      "rectangle"
      "slack"
      "steam"
      "tableplus"
      "zoom"
      "vmware-fusion-tech-preview"
      "wezterm"
      "aerospace"
      "betterdisplay"
      "bettertouchtool"
      "orbstack"
      "obsidian"
      "raycast"
      "readdle-spark"
      "scroll-reverser"
      "syncthing"
      "visual-studio-code"
      "todoist"
    ];
  };

  services.nix-daemon.enable = true;

  system.stateVersion = 4;

}

