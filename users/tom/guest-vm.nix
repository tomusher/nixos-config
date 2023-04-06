{ config, pkgs, inputs, ... }:

{
  imports = [ ./apps/common.nix ./apps/linux-desktop.nix ];
}
