{ pkgs, ... }:

let
  secrets = import ../../secrets/secrets.nix;
in {
  imports = [
    ../../modules/selfhosted
  ];
  virtualisation =
    {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.dnsname.enable = true;
      };
      oci-containers.backend = "podman";
      containers.enable = true;

    };
  selfhosted.traefik = {
    enable = true;
    configDir = /srv/traefik;
    environment = {
      CF_API_EMAIL = secrets.cloudflare_api_email;
      CF_API_KEY = secrets.cloudflare_api_key;
    };
  };
  selfhosted.redis = {
    enable = true;
  };
  selfhosted.homeassistant = {
    enable = true;
    configDir = /srv/homeassistant;
  };
  selfhosted.appdaemon = {
    enable = true;
    configDir = /srv/appdaemon;
    traefikHost = "appdaemon.home.tomusher.com";
  };
  selfhosted.adguard = {
    enable = true;
    configDir = /srv/adguard/config;
    dataDir = /srv/adguard/data;
    traefikHost = "adguard.home.tomusher.com";
    dnsPort = 9953;
  };
  selfhosted.calibre = {
    enable = true;
    configDir = /srv/calibre;
    traefikHost = "calibre.home.tomusher.com";
  };
  selfhosted.calibre-web = {
    enable = true;
    configDir = /srv/calibre-web;
    traefikHost = "calibre-web.home.tomusher.com";
  };
  selfhosted.changedetection = {
    enable = true;
    dataDir = /srv/changedetection;
    traefikHost = "changedetection.home.tomusher.com";
  };
  selfhosted.bazarr = {
    enable = true;
    configDir = /srv/bazarr;
    traefikHost = "bazarr.home.tomusher.com";
  };
  selfhosted.sonarr = {
    enable = true;
    configDir = /srv/sonarr;
    traefikHost = "sonarr.home.tomusher.com";
  };
  selfhosted.radarr = {
    enable = true;
    configDir = /srv/radarr;
    traefikHost = "radarr.home.tomusher.com";
  };
}
