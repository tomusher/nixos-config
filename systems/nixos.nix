{ config, pkgs, ... }:

{
  system.stateVersion = "22.05";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.opengl = {
    enable = true;
    extraPackages = [ pkgs.mesa.drivers ];
  };

  i18n.defaultLocale = "en_GB.UTF-8";

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 30d";
  };
}
