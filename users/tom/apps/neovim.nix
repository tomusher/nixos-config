{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.neovim
  ];

  home.file."/.config/nvim" = {
    source = ./files/nvim;
    recursive = true;
  };
}
