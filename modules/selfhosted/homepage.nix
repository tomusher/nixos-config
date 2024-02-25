{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.homepage;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
{
  options.selfhosted.homepage = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "ghcr.io/gethomepage/homepage";
      };
    configDir = mkOption { type = types.path; };
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
    virtualisation.oci-containers.containers.homepage = {
      autoStart = false;
      image = cfg.image;
      ports = [ "3000" ];
      volumes = [ "${toString cfg.configDir}:/app/config" "/var/run/docker.sock:/var/run/docker.sock:ro" ] ++ cfg.mounts;
      environment = { TZ = "Europe/London"; PUID = "1000"; PGID = "1000"; };
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "homepage";
          host = cfg.traefikHost;
          port = 3000;
        };
    };
  };
}
