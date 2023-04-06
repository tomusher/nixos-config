{ config, pkgs, currentSystem, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.hyprland.nixosModules.default
  ];

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Enable swap on luks
  boot.initrd.luks.devices."luks-844fcb12-b593-4a25-9581-a379838c9cc3".device = "/dev/disk/by-uuid/844fcb12-b593-4a25-9581-a379838c9cc3";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

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
  security.sudo.wheelNeedsPassword = false;

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

