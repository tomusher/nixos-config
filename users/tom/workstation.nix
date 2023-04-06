{ config, pkgs, inputs, ... }:

{
  imports = [ ./apps/common.nix ./apps/wayland-desktop.nix ];

  home.packages = [
    pkgs.zoom-us
    pkgs.plex-media-player
    pkgs.obs-studio
    pkgs.newsboat
    pkgs.mpv
    pkgs.brave
    pkgs.flameshot
    pkgs.discord
    pkgs.slack
    pkgs.texlive.combined.scheme-basic
    pkgs.pavucontrol
    pkgs._1password
    pkgs._1password-gui
  ];
}
