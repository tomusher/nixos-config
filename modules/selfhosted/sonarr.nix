{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.sonarr;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
rec {
  options.selfhosted.sonarr = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "lscr.io/linuxserver/sonarr:develop";
      };
    configDir = mkOption { type = types.path; };
    mounts = mkOption
      {
        type = types.listOf types.str;
        default = [ ];
      };
    traefikHost = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.sonarr = {
      autoStart = true;
      image = cfg.image;
      ports = [ "8989" ];
      volumes = [ "${toString cfg.configDir}:/config" ] ++ cfg.mounts;
      environment = { TZ = "Europe/London"; PUID = "1000"; PGID = "1000"; };
      extraOptions = [
        "-l io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "sonarr";
          host = cfg.traefikHost;
          port = 8989;
        };
    };
  };
}
