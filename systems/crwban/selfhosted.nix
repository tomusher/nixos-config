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
        defaultNetwork.dnsname.enable = true;
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
  selfhosted.roomassistant = {
    enable = true;
    configDir = /srv/config/roomassistant;
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
    libraryDir = /mnt/big/eBooks;
    traefikHost = "calibre.home.tomusher.com";
  };
  selfhosted.calibre-web = {
    enable = true;
    configDir = /srv/config/calibre-web;
    libraryDir = /mnt/big/eBooks;
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
    downloadsDir = /mnt/big/downloads;
    incompleteDownloadsDir = /mnt/big/incomplete-downloads;
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
    mounts = [
      "/mnt/disk1/Videos/Episodic:/tv"
      "/mnt/big/Videos/Episodic:/tv2"
      "/mnt/big/downloads:/downloads"
    ];
  };
  selfhosted.radarr = {
    enable = true;
    configDir = /srv/config/radarr;
    traefikHost = "radarr.home.tomusher.com";
    mounts = [
      "/mnt/big/downloads:/downloads"
      "/mnt/disk2/Videos/Films:/movies"
      "/mnt/big/Videos/Films:/movies2"
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
    configDir = /srv/config/paperless;
    dataDir = /srv/data/paperless;
    traefikHost = "paperless.home.tomusher.com";
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
  selfhosted.silverbullet = {
    enable = true;
    dataDir = /srv/data/silverbullet;
    traefikHost = "notes.home.tomusher.com";
  };
  selfhosted.plex = {
    enable = true;
    traefikHost = "plex.home.tomusher.com";
    configDir = /srv/config/plex;
    extraMounts = [
      "/mnt/disk1/Videos/Episodic:/data/tvshows"
      "/mnt/disk2/Videos/Episodic:/data/tvshows2"
      "/mnt/disk1/Videos/Films:/data/movies"
      "/mnt/disk2/Videos/Films:/data/movies2"
      "/mnt/big/Videos/Episodic:/data/tvshows3"
      "/mnt/big/Videos/Films:/data/movies3"
      "/mnt/big/music:/data/music"
    ];
  };
}
