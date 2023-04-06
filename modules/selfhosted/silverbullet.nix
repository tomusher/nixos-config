{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.silverbullet;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
{
  options.selfhosted.silverbullet = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "docker.io/zefhemel/silverbullet";
      };
    dataDir = mkOption { type = types.path; };
    traefikHost = mkOption { type = types.str; };
    labels = mkOption
      {
        type = types.listOf types.str;
        default = [ ];
      };
  };


  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.silverbullet = {
      autoStart = false;
      image = cfg.image;
      ports = [ "3000" ];
      volumes = [ "${toString cfg.dataDir}:/space" ];
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "silverbullet";
          host = cfg.traefikHost;
          port = 3000;
        };
    };
  };
}
