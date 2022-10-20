{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.zigbee2mqtt;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
rec {
  options.selfhosted.zigbee2mqtt = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "docker.io/koenkk/zigbee2mqtt:latest-dev";
      };
    configDir = mkOption { type = types.path; };
    traefikHost = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.zigbee2mqtt = {
      autoStart = true;
      image = cfg.image;
      ports = [ "8080" ];
      volumes = [ "${toString cfg.configDir}:/app/data" ];
      extraOptions = [
        "--device=/dev/ttyUSB0:/dev/ttyUSB0"
        "-l=io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "zigbee2mqtt";
          host = cfg.traefikHost;
          port = 8080;
        };
    };
  };
}
