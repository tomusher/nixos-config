{ config, pkgs, currentSystem, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.hyprland.nixosModules.default
    ../../users/tom/nixos-user.nix
  ];

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  home-manager.users.tom = { pkgs, ... }: {
    home.packages = [
      pkgs.zoom-us
      pkgs.plex-media-player
      pkgs.obs-studio
      pkgs.newsboat
      pkgs.mpv
      pkgs.brave
      pkgs.flameshot
      pkgs.discord
      pkgs.slack
      pkgs.texlive.combined.scheme-basic
      pkgs.pavucontrol
      pkgs._1password
      pkgs._1password-gui
    ];
    imports = [ ./apps/common.nix ./apps/wayland-desktop.nix ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    inputs.devenv.packages.${pkgs.stdenv.hostPlatform.system}.devenv
    slurp
    grim
    #    inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
  ];

  programs.hyprland.enable = true;

  virtualisation.docker.enable = true;

  time.timeZone = "Europe/London";

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    keyMap = "uk";
  };

  users.mutableUsers = false;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  services.pipewire.enable = true;
  services.pipewire.pulse.enable = true;
  services.pipewire.wireplumber.enable = true;
}

