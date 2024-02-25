{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.glances;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
{
  options.selfhosted.glances = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "docker.io/nicolargo/glances:latest-full";
      };
    labels = mkOption
      {
        type = types.listOf types.str;
        default = [ ];
      };
    traefikHost = mkOption { type = types.str; };
  };


  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.glances = {
      autoStart = true;
      image = cfg.image;
      ports = [ "61208" ];
      environment = {
        GLANCES_OPT = "-w -t 15";
      };
      volumes = [ "/var/run/docker.sock:/var/run/docker.sock:ro" ];
      extraOptions = [
        "--privileged=true"
        "--pid=host"
        "--network=host"
        "-l=io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "glances";
          host = cfg.traefikHost;
          port = 61208;
        };
    };
  };
}
