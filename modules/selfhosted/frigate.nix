{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.frigate;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
{
  options.selfhosted.frigate = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "ghcr.io/blakeblackshear/frigate:0.12.0-beta5";
      };
    configDir = mkOption { type = types.path; };
    mediaDir = mkOption { type = types.path; };
    traefikHost = mkOption { type = types.str; };
    labels = mkOption
      {
        type = types.listOf types.str;
        default = [ ];
      };
  };


  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.frigate = {
      autoStart = true;
      image = cfg.image;
      ports = [ "5000" "1935" ];
      volumes = [ "${toString cfg.configDir}:/config" "${toString cfg.mediaDir}:/media/frigate" "/etc/localtime:/etc/localtime" ];
      extraOptions = [
        "--privileged=true"
        "--device=/dev/bus/usb:/dev/bus/usb"
        "--device=/dev/dri/renderD128"
        "-l=io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "frigate";
          host = cfg.traefikHost;
          port = 5000;
        };
    };
  };
}
