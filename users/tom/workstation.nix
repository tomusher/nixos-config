{ config, pkgs, ... }:

{
  imports = [ ./apps/common.nix ];

  home.packages = [
    pkgs.ferdi
    pkgs.zoom-us
    pkgs.v4l2loopback
    pkgs.plex-media-player
    pkgs.obs-studio
    pkgs.newsboat
    pkgs.mpv
    pkgs.brave
    pkgs.flameshot
    pkgs.discord
    pkgs.texlive.combined.scheme-basic
  ];
}
