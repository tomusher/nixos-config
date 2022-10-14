{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.calibre-web;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
{
  options.selfhosted.calibre-web = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "lscr.io/linuxserver/calibre-web";
      };
    configDir = mkOption { type = types.path; };
    traefikHost = mkOption { type = types.str; };
    labels = mkOption
      {
        type = types.listOf types.str;
        default = [ ];
      };
  };


  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.calibre-web = {
      autoStart = true;
      image = cfg.image;
      ports = [ "8083" ];
      volumes = [ "${toString cfg.configDir}:/config" ];
      environment = { TZ = "Europe/London"; PUID = "1000"; PGID = "1000"; };
      extraOptions = [
        "-l io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "calibre-web";
          host = cfg.traefikHost;
          port = 8080;
        };
    };
  };
}
