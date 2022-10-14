{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.grocy;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
{
  options.selfhosted.grocy = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "docker.io/linuxserver/grocy";
      };
    configDir = mkOption { type = types.path; };
    mediaDir = mkOption { type = types.path; };
    traefikHost = mkOption { type = types.str; };
    labels = mkOption
      {
        type = types.listOf types.str;
        default = [ ];
      };
  };


  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.frigate = {
      autoStart = true;
      image = cfg.image;
      ports = [ "80" "3306" ];
      volumes = [ "${toString cfg.configDir}:/config/" ];
      environment = { TZ = "Europe/London"; PUID = "1000"; PGID = "1000"; };
      extraOptions = [
        "-l io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "grocy";
          host = cfg.traefikHost;
          port = 80;
        };
    };
  };
}
