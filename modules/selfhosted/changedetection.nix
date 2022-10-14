{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.changedetection;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
{
  options.selfhosted.changedetection = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "docker.io/dgtlmoon/changedetection.io";
      };
    dataDir = mkOption { type = types.path; };
    traefikHost = mkOption { type = types.str; };
    labels = mkOption
      {
        type = types.listOf types.str;
        default = [ ];
      };
  };


  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.changedetection = {
      autoStart = true;
      image = cfg.image;
      ports = [ "5000" ];
      volumes = [ "${toString cfg.dataDir}:/datastore" ];
      environment = { TZ = "Europe/London"; PUID = "1000"; PGID = "1000"; };
      extraOptions = [
        "-l io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "changedetection";
          host = cfg.traefikHost;
          port = 5000;
        };
    };
  };
}
