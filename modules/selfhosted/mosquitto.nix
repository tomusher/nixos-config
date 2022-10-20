{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.mosquitto;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
{
  options.selfhosted.mosquitto = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "docker.io/eclipse-mosquitto";
      };
    traefikHost = mkOption { type = types.str; };
    configDir = mkOption { type = types.path; };
    dataDir = mkOption { type = types.path; };
    logDir = mkOption { type = types.path; };
    labels = mkOption
      {
        type = types.listOf types.str;
        default = [ ];
      };
  };


  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.mosquitto = {
      autoStart = true;
      image = cfg.image;
      ports = [ "1883:1883" "9001:9001" ];
      volumes = [ "${toString cfg.configDir}:/mosquitto/config" "${toString cfg.dataDir}:/mosquitto/data" "${toString cfg.logDir}:/mosquitto/log" ];
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ]);
    };
  };
}
