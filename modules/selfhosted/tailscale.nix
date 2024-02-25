{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.tailscale;
  backend = config.virtualisation.oci-containers.backend;
in
{
  options.selfhosted.tailscale = {
    enable = mkOption { type = types.bool; default = false; };
    image = mkOption
      {
        type = types.str;
        default = "docker.io/tailscale/tailscale";
      };
    configDir = mkOption { type = types.path; };
    environment = mkOption
      {
        type = types.attrs;
        default = {};
      };
    labels = mkOption
      {
        type = types.listOf types.str;
        default = [ ];
      };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.tailscale = {
      autoStart = true;
      image = cfg.image;
      volumes = [ "${toString cfg.configDir}:/var/lib" "/dev/net/tun:/dev/net/tun" ];
      environment = { TZ = "Europe/London"; TS_STATE_DIR = "/var/lib/tailscale"; } // cfg.environment;
      extraOptions = [
        "--network=host"
        "--cap-add=NET_ADMIN"
        "--cap-add=NET_RAW"
        "--privileged=true"
        "-l=io.containers.autoupdate=registry"
      ] ++ forEach cfg.labels (l: "-l $(l)");
    };
  };
}
