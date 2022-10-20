{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.appdaemon;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
rec {
  options.selfhosted.appdaemon = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "docker.io/acockburn/appdaemon";
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
    virtualisation.oci-containers.containers.appdaemon = {
      autoStart = true;
      image = cfg.image;
      ports = [ "5050" ];
      volumes = [ "${toString cfg.configDir}:/conf" ];
      environment = { TZ = "Europe/London"; };
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "appdaemon";
          host = cfg.traefikHost;
          port = 8080;
        };
    };
  };
}
