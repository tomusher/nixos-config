{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.influxdb;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
{
  options.selfhosted.influxdb = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "docker.io/influxdb";
      };
    configDir = mkOption { type = types.path; };
    dataDir = mkOption { type = types.path; };
    traefikHost = mkOption { type = types.str; };
    labels = mkOption
      {
        type = types.listOf types.str;
        default = [ ];
      };
    environment = mkOption { type = types.attrsOf types.str; };
  };


  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.influxdb = {
      autoStart = true;
      image = cfg.image;
      ports = [ "8086" ];
      volumes = [ "${toString cfg.configDir}:/etc/influxdb2" "${toString cfg.dataDir}:/var/lib/influxdb2" ];
      environment = cfg.environment;
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "influxdb";
          host = cfg.traefikHost;
          port = 8086;
        };
    };
  };
}
