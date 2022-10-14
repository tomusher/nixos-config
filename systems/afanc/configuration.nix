{ config, pkgs, currentSystem, home-manager, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  time.timeZone = "Europe/London";

  networking.useDHCP = false;
  networking.interfaces.ens160.useDHCP = true;

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    keyMap = "uk";
  };
  security.sudo.wheelNeedsPassword = false;

  services.xserver = {
    enable = true;
    layout = "gb";
    dpi = 220;

    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "scale";
    };

    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;

      sessionCommands = "${pkgs.xorg.xset}/bin/xset r rate 200 40";
    };

    resolutions = [{ x = 3024; y = 1964; }];

    windowManager = {
      i3.enable = true;
    };
  };

  users.mutableUsers = false;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;
}

