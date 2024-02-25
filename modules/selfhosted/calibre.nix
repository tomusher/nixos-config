{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.calibre;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
{
  options.selfhosted.calibre = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "lscr.io/linuxserver/calibre";
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
    virtualisation.oci-containers.containers.calibre = {
      autoStart = false;
      image = cfg.image;
      ports = [ "8080" "8081" ];
      volumes = [ "${toString cfg.configDir}:/config" ] ++ cfg.mounts;
      environment = { TZ = "Europe/London"; PUID = "1000"; PGID = "1000"; };
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "calibre";
          host = cfg.traefikHost;
          port = 8080;
        };
    };
  };
}
