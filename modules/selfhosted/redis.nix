{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.redis;
  backend = config.virtualisation.oci-containers.backend;
in
{
  options.selfhosted.redis = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "docker.io/redis";
      };
    port = mkOption
      {
        type = types.str;
        default = "6379";
      };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.redis = {
      autoStart = true;
      image = cfg.image;
      ports = [ "${cfg.port}:6379" ];
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ]);
    };
  };
}
