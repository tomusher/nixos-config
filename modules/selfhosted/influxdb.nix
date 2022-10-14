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
  };


  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.influxdb = {
      autoStart = true;
      image = cfg.image;
      ports = [ "8086" ];
      volumes = [ "${toString cfg.configDir}:/etc/influxdb2" "${toString cfg.dataDir}:/var/lib/influxdb2" ];
      environment = {
        DOCKER_INFLUXDB_INIT_MODE = setup;
        DOCKER_INFLUXDB_INIT_USERNAME = db;
        DOCKER_INFLUXDB_INIT_PASSWORD = dbpass123pass;
        DOCKER_INFLUXDB_INIT_ORG = home;
        DOCKER_INFLUXDB_INIT_BUCKET = home;
        DOCKER_INFLUXDB_INIT_ADMIN_TOKEN = home-token;
      };
      extraOptions = [
        "-l io.containers.autoupdate=registry"
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
