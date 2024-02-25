{ config, pkgs, hostname, ... }:

{
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Europe/London";

  environment.systemPackages = with pkgs; [
    git
    python310
    wmctrl
    nil
    nixpkgs-fmt
    ripgrep
    coreutils
    fd
    jq
    clang
    neovim
    killall
    git
    fira-code
    nnn
  ];

  environment.variables.NIXOS_OZONE_WL = "1";

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    fira-code
  ];

  nix = {
    package = pkgs.nixVersions.stable;

    settings.auto-optimise-store = true;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
