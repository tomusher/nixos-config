{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.homeassistant;
  backend = config.virtualisation.oci-containers.backend;
in
{
  options.selfhosted.homeassistant = {
    enable = mkOption { type = types.bool; default = false; };
    image = mkOption
      {
        type = types.str;
        default = "docker.io/homeassistant/home-assistant";
      };
    configDir = mkOption { type = types.path; };
    labels = mkOption
      {
        type = types.listOf types.str;
        default = [ ];
      };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.homeassistant = {
      autoStart = true;
      image = cfg.image;
      volumes = [ "${toString cfg.configDir}:/config" ];
      environment = { TZ = "Europe/London"; };
      extraOptions = [
        "--network=host"
        "--privileged=true"
        "-l io.containers.autoupdate=registry"
      ] ++ forEach cfg.labels (l: "-l $(l)");
    };
  };
}
