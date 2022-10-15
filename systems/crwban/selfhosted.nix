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
  selfhosted.postgres = {
    enable = true;
    dataDir = /srv/data/postgres;
    environment = {
      POSTGRES_PASSWORD = "postgres";
    };
  };
  selfhosted.influxdb = {
    enable = true;
    dataDir = /srv/data/influxdb;
    configDir = /srv/config/influxdb;
    environment = {
      DOCKER_INFLUXDB_INIT_MODE = "setup";
      DOCKER_INFLUXDB_INIT_USERNAME = "db";
      DOCKER_INFLUXDB_INIT_PASSWORD = "dbpass123pass";
      DOCKER_INFLUXDB_INIT_ORG = "home";
      DOCKER_INFLUXDB_INIT_BUCKET = "home";
      DOCKER_INFLUXDB_INIT_ADMIN_TOKEN = "home-token";
    };
    traefikHost = "influxdb.home.tomusher.com";
  };
  selfhosted.traefik = {
    enable = true;
    configDir = /srv/config/traefik;
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
    configDir = /srv/config/homeassistant;
  };
  selfhosted.appdaemon = {
    enable = true;
    configDir = /srv/config/appdaemon;
    traefikHost = "appdaemon.home.tomusher.com";
  };
  selfhosted.zigbee2mqtt = {
    enable = true;
    configDir = /srv/config/zigbee2mqtt;
    traefikHost = "zigbee2mqtt.home.tomusher.com";
  };
  selfhosted.mosquitto = {
    enable = true;
    configDir = /srv/config/mosquitto;
    dataDir = /srv/data/mosquitto;
    logDir = /srv/data/mosquitto-logs;
    traefikHost = "mosquitto.home.tomusher.com";
  };
  selfhosted.miniflux = {
    enable = true;
    traefikHost = "miniflux.home.tomusher.com";
  };
  selfhosted.adguard = {
    enable = true;
    configDir = /srv/config/adguard;
    dataDir = /srv/data/adguard;
    traefikHost = "adguard.home.tomusher.com";
    dnsPort = 9953;
  };
  selfhosted.calibre = {
    enable = true;
    configDir = /srv/config/calibre;
    libraryDir = /tmp/library;
    traefikHost = "calibre.home.tomusher.com";
  };
  selfhosted.calibre-web = {
    enable = true;
    configDir = /srv/config/calibre-web;
    traefikHost = "calibre-web.home.tomusher.com";
  };
  selfhosted.changedetection = {
    enable = true;
    dataDir = /srv/data/changedetection;
    traefikHost = "changedetection.home.tomusher.com";
  };
  selfhosted.sabnzbd = {
    enable = true;
    configDir = /srv/config/sabnzbd;
    downloadsDir = /tmp/downloads;
    incompleteDownloadsDir = /tmp/incomplete-downloads;
    traefikHost = "sabnzbd.home.tomusher.com";
  };
  selfhosted.bazarr = {
    enable = true;
    configDir = /srv/config/bazarr;
    traefikHost = "bazarr.home.tomusher.com";
  };
  selfhosted.sonarr = {
    enable = true;
    configDir = /srv/config/sonarr;
    traefikHost = "sonarr.home.tomusher.com";
  };
  selfhosted.radarr = {
    enable = true;
    configDir = /srv/config/radarr;
    traefikHost = "radarr.home.tomusher.com";
  };
  selfhosted.frigate = {
    enable = true;
    configDir = /srv/config/frigate;
    mediaDir = /tmp/frigate;
    traefikHost = "frigate.home.tomusher.com";
  };
  selfhosted.paperless = {
    enable = true;
    configDir = /srv/config/paperless;
    dataDir = /tmp/paperless;
    traefikHost = "paperless.home.tomusher.com";
  };
}
