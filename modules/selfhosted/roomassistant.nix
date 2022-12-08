{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.roomassistant;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
rec {
  options.selfhosted.roomassistant = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "docker.io/mkerix/room-assistant";
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
    virtualisation.oci-containers.containers.roomassistant = {
      autoStart = true;
      image = cfg.image;
      volumes = [ "${toString cfg.configDir}:/room-assistant/config" ];
      environment = { TZ = "Europe/London"; };
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ]);
    };
  };
}
