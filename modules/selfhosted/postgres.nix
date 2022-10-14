{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.postgres;
  backend = config.virtualisation.oci-containers.backend;
in
{
  options.selfhosted.postgres = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "docker.io/postgres:12";
      };
    dataDir = mkOption { type = types.path; };
    port = mkOption
      {
        type = types.str;
        default = "5432";
      };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.postgres = {
      autoStart = true;
      image = cfg.image;
      ports = [ "${cfg.port}:5432" ];
      volumes = [ "${toString cfg.dataDir}:/var/lib/postgresql/data" ];
      environment = { POSTGRES_PASSWORD = "postgres"; };
      extraOptions = [
        "-l io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ]);
    };
  };
}
