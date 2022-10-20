{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.fava;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
{
  options.selfhosted.fava = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "fava";
      };
    configDir = mkOption { type = types.path; };
    labels = mkOption
      {
        type = types.listOf types.str;
        default = [ ];
      };
    traefikHost = mkOption { type = types.str; };
  };


  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.fava = {
      autoStart = true;
      image = cfg.image;
      ports = [ "8000" "8001" ];
      volumes = [ "${toString cfg.configDir}:/bean" ];
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "fava";
          host = cfg.traefikHost;
          port = 8000;
        };
    };
  };
}
