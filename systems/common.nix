{ config, pkgs, hostname, ... }:

{
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Europe/London";

  environment.systemPackages = with pkgs; [
    git
    python311
    python311.pkgs.pip
    python311.pkgs.pipx
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
    lazygit
  ];

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
