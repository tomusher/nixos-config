{ config, pkgs, inputs, ... }:

{
  imports = [ ./apps/common.nix ./apps/desktop.nix ];
}
