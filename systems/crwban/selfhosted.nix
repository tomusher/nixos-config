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
        dockerSocket.enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      oci-containers.backend = "podman";
      containers.enable = true;

    };
  selfhosted.postgres = {
    enable = true;
    dataDir = /srv/data/postgres/14/data;
    environment = {
      POSTGRES_PASSWORD = "postgres";
    };
  };
  selfhosted.influxdb = {
    enable = false;
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
    traefikHost = "calibre.home.tomusher.com";
    mounts = [
      "/mnt/morfil/media:/data"
    ];
  };
  selfhosted.calibre-web = {
    enable = true;
    configDir = /srv/config/calibre-web;
    libraryDir = /mnt/morfil/media/eBooks;
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
    traefikHost = "sabnzbd.home.tomusher.com";
    mounts = [
      "/mnt/morfil/media:/data"
    ];
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
    mounts = [
      "/mnt/morfil/media:/data"
    ];
  };
  selfhosted.radarr = {
    enable = true;
    configDir = /srv/config/radarr;
    traefikHost = "radarr.home.tomusher.com";
    mounts = [
      "/mnt/morfil/media:/data"
    ];
  };
  selfhosted.prowlarr = {
    enable = true;
    configDir = /srv/config/prowlarr;
    traefikHost = "prowlarr.home.tomusher.com";
  };
  selfhosted.frigate = {
    enable = true;
    configDir = /srv/config/frigate;
    mediaDir = /mnt/big/shared/frigate;
    traefikHost = "frigate.home.tomusher.com";
  };
  selfhosted.paperless = {
    enable = true;
    traefikHost = "paperless.home.tomusher.com";
    mounts = [
      "/mnt/morfil/files:/data"
    ];
    environment = {
      PAPERLESS_REDIS = "redis://redis:6379";
      PAPERLESS_DATA_DIR = "/data/documents/paperless-data";
      PAPERLESS_MEDIA_ROOT = "/data/documents";
    };
  };
  selfhosted.glances = {
    enable = true;
    traefikHost = "glances.home.tomusher.com";
  };
  selfhosted.unifi = {
    enable = true;
    configDir = /srv/config/unifi;
    traefikHost = "unifi.home.tomusher.com";
  };
  selfhosted.fava = {
    enable = true;
    configDir = /srv/config/money;
    traefikHost = "fava.home.tomusher.com";
  };
  selfhosted.plex = {
    enable = true;
    traefikHost = "plex.home.tomusher.com";
    configDir = /srv/config/plex;
    extraMounts = [
      "/mnt/morfil/media:/data"
    ];
  };
  selfhosted.tailscale = {
    enable = true;
    configDir = /srv/config/tailscale;
    environment = {
      TS_AUTHKEY = secrets.tailscale_auth_key;
      TS_EXTRA_ARGS = "--advertise-routes=192.168.0.0/24 --advertise-exit-node";
    };
  };
  selfhosted.homepage = {
    enable = true;
    configDir = /srv/config/homepage;
    traefikHost = "home.tomusher.com";
  };
}
