{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.scrypted;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
{
  options.selfhosted.scrypted = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "docker.io/koush/scrypted";
      };
    configDir = mkOption { type = types.path; };
    nvrDir = mkOption { type = types.path; };
    traefikHost = mkOption { type = types.str; };
    labels = mkOption
      {
        type = types.listOf types.str;
        default = [ ];
      };
  };


  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.scrypted = {
      autoStart = true;
      image = cfg.image;
      ports = [ "11080" "33325:33325" ];
      volumes = [ "${toString cfg.configDir}:/server/volume" "${toString cfg.nvrDir}:/nvr" ];
      extraOptions = [
        "--privileged=true"
        "--device=/dev/bus/usb:/dev/bus/usb"
        "--device=/dev/dri/renderD128"
        "-l=io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "scrypted";
          host = cfg.traefikHost;
          port = 11080;
        };
    };
  };
}
