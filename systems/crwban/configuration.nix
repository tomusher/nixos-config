{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./selfhosted.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = false;
  networking.interfaces.ens18.useDHCP = true;

  networking.firewall.enable = false;

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    keyMap = "uk";
  };

  environment.systemPackages = with pkgs; [
    podman
  ];

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";
}

