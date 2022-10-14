{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.traefik;
  backend = config.virtualisation.oci-containers.backend;
in
rec {
  options.selfhosted.traefik = {
    enable = mkOption { type = types.bool; default = false; };
    image = mkOption
      {
        type = types.str;
        default = "docker.io/traefik";
      };
    configDir = mkOption { type = types.path; };
    traefikHost = mkOption { type = types.str; };
    environment = mkOption { type = types.attrsOf types.str; };
  };

  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.traefik = {
      autoStart = true;
      image = cfg.image;
      ports = [ "80:80" "443:443" "8080" ];
      volumes = [ "${toString cfg.configDir}:/" "/var/run/docker.sock:/var/run/docker.sock:ro" ];
      environment = cfg.environment;
      extraOptions = [
        "-l io.containers.autoupdate=registry"
      ];
    };
  };
}
