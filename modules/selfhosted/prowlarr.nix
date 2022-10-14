{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.prowlarr;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
rec {
  options.selfhosted.prowlarr = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "lscr.io/linuxserver/prowlarr:develop";
      };
    configDir = mkOption { type = types.path; };
    traefikHost = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.prowlarr = {
      autoStart = true;
      image = cfg.image;
      ports = [ "9696" ];
      volumes = [ "${toString cfg.configDir}:/config" ];
      environment = { TZ = "Europe/London"; PUID = "1000"; PGID = "1000"; };
      extraOptions = [
        "-l io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "prowlarr";
          host = cfg.traefikHost;
          port = 9696;
        };
    };
  };
}
