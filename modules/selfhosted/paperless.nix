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
        default = "ghcr.io/paperless-ngx/paperless-ngx:latest";
      };
    environment = mkOption
      {
        type = types.attrs;
        default = {};
      };
    mounts = mkOption
      {
        type = types.listOf types.str;
        default = [ ];
      };
    traefikHost = mkOption { type = types.str; };
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
      volumes = cfg.mounts;
      environment = {
        PAPERLESS_TIME_ZONE = "Europe/London";
        USERMAP_UID = "0";
        USERMAP_GID = "0";
        PAPERLESS_URL = "https://" + cfg.traefikHost;
      } // cfg.environment;
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
