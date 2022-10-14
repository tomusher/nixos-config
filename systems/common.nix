{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";
  system.stateVersion = "22.05";

  boot.kernelPackages = pkgs.linuxPackages_latest; 

  hardware.opengl = {
    enable = true;
    extraPackages = [ pkgs.mesa.drivers ];
  };

  environment.systemPackages = with pkgs; [
    git
    python39
    nodejs
    wmctrl
    nixpkgs-fmt
    emacs
    ripgrep
    coreutils
    fd
    clang
    neovim
    killall
    git
    fira-code
    nnn
  ];

  nix = {
    package = pkgs.nixVersions.stable;

    settings.auto-optimise-store = true;

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 30d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
