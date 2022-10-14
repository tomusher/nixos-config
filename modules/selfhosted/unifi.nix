{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.unifi;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
rec {
  options.selfhosted.unifi = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "lscr.io/linuxserver/unifi-controller";
      };
    configDir = mkOption { type = types.path; };
    traefikHost = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.unifi = {
      autoStart = true;
      image = cfg.image;
      ports = [ "3478:3478/udp" "10001:10001/udp" "8080:8080" "8081:8081" "8443:8443" "8843:8843" "8880:8880" "6789:6789" ];
      volumes = [ "${toString cfg.configDir}:/config" ];
      environment = { TZ = "Europe/London"; PUID = "1000"; PGID = "1000"; };
      extraOptions = [
        "-l io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "unifi";
          host = cfg.traefikHost;
          port = 8443;
          scheme = "https";
        };
    };
  };
}
