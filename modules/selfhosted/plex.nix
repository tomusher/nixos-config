{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.plex;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
{
  options.selfhosted.plex = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "lscr.io/linuxserver/plex";
      };
    traefikHost = mkOption { type = types.str; };
    configDir = mkOption { type = types.path; };
    extraMounts = mkOption {
      type = types.listof types.str;
      default = [ ];
    };
    labels = mkOption
      {
        type = types.listOf types.str;
        default = [ ];
      };
  };


  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.plex = {
      autoStart = true;
      image = cfg.image;
      volumes = [ "${toString cfg.configDir}:/config" ] ++ extraMounts;
      environment = {
        TZ = "Europe/London";
        PUID = "1000";
        PGID = "1000";
        VERSION = "latest";
      };
      extraOptions = [
        "--device=/dev/dri"
        "-l io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "plex";
          host = cfg.traefikHost;
          port = 8000;
        };
    };
  };
}
