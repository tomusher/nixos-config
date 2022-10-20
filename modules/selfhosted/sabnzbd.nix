{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.sabnzbd;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
rec {
  options.selfhosted.sabnzbd = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "lscr.io/linuxserver/sabnzbd";
      };
    configDir = mkOption { type = types.path; };
    downloadsDir = mkOption { type = types.path; };
    incompleteDownloadsDir = mkOption { type = types.path; };
    mounts = mkOption
      {
        type = types.listOf types.str;
        default = [ ];
      };
    traefikHost = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.sabnzbd = {
      autoStart = true;
      image = cfg.image;
      ports = [ "8080" ];
      volumes = [ "${toString cfg.configDir}:/config" "${toString cfg.downloadsDir}:/downloads" "${toString cfg.incompleteDownloadsDir}:/incomplete-downloads" ];
      environment = { TZ = "Europe/London"; PUID = "1000"; PGID = "1000"; };
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "sabnzbd";
          host = cfg.traefikHost;
          port = 8080;
        };
    };
  };
}
