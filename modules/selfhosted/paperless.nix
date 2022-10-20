{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.paperless;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
{
  options.selfhosted.paperless = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "lscr.io/linuxserver/paperless-ngx";
      };
    traefikHost = mkOption { type = types.str; };
    configDir = mkOption { type = types.path; };
    dataDir = mkOption { type = types.path; };
    labels = mkOption
      {
        type = types.listOf types.str;
        default = [ ];
      };
  };


  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.paperless = {
      autoStart = true;
      image = cfg.image;
      ports = [ "8000" ];
      volumes = [ "${toString cfg.configDir}:/config" "${toString cfg.dataDir}:/data" ];
      environment = {
        TZ = "Europe/London";
        PUID = "1000";
        PGID = "1000";
        PAPERLESS_URL = cfg.traefikHost;
      };
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "paperless";
          host = cfg.traefikHost;
          port = 8000;
        };
    };
  };
}
