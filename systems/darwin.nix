{ config, pkgs, ... }:

{
  nix.gc = {
    automatic = true;
    interval = {
      Hour = 9;
      Minute = 0;
    };
    options = "--delete-older-than 30d";
  };
}
