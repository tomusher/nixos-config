{ config, pkgs, inputs, ... }:
{
  imports = [
    ./zsh.nix
    ./neovim.nix
  ];

  home.stateVersion = "22.05";

  home.packages = [
  ];

  programs.git = {
    enable = true;
    userName = "Tom Usher";
    userEmail = "tom@tomusher.com";
  };
}
