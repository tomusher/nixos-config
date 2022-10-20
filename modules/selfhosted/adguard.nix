{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.adguard;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
rec {
  options.selfhosted.adguard = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "docker.io/adguard/adguardhome:beta";
      };
    dnsPort = mkOption { type = types.int; };
    configDir = mkOption { type = types.path; };
    dataDir = mkOption { type = types.path; };
    traefikHost = mkOption { type = types.str; };
    labels = mkOption
      {
        type = types.listOf types.str;
        default = [ ];
      };
  };

  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.adguard = {
      autoStart = true;
      image = cfg.image;
      ports = [
        "${toString cfg.dnsPort}:53/tcp"
        "${toString cfg.dnsPort}:53/udp"
        "67:67/udp" "3000:3000/tcp" "853:853/tcp" "80"
      ];
      volumes = [ "${toString cfg.configDir}:/opt/adguardhome/conf" "${toString cfg.dataDir}:/opt/adguardhome/work" ];
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "adguard";
          host = cfg.traefikHost;
          port = 80;
        };
    };
  };
}
