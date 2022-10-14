{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.miniflux;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
{
  options.selfhosted.miniflux = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "docker.io/miniflux/miniflux";
      };
    traefikHost = mkOption { type = types.str; };
    labels = mkOption
      {
        type = types.listOf types.str;
        default = [ ];
      };
  };


  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.miniflux = {
      autoStart = true;
      image = cfg.image;
      ports = [ "8080" ];
      environment = {
        TZ = "Europe/London";
        PUID = "1000";
        PGID = "1000";
        DATABASE_URL = "postgres://postgres:postgres@postgres/miniflux?sslmode=disable";
        RUN_MIGRATIONS = 1;
      };
      extraOptions = [
        "-l io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "miniflux";
          host = cfg.traefikHost;
          port = 8080;
        };
    };
  };
}
