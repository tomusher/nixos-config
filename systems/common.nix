{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Europe/London";

  environment.systemPackages = with pkgs; [
    git
    python39
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

  nix = {
    package = pkgs.nixVersions.stable;

    settings.auto-optimise-store = true;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
