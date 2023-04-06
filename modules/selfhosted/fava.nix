{ config, lib, ... }:

with lib;
let
  cfg = config.selfhosted.fava;
  backend = config.virtualisation.oci-containers.backend;
  utils = import ./utils.nix;
in
{
  options.selfhosted.fava = {
    enable = mkOption { type = types.bool; default = false; };
    network = mkOption { type = types.str; default = ""; };
    image = mkOption
      {
        type = types.str;
        default = "localhost/moneytools";
      };
    configDir = mkOption { type = types.path; };
    labels = mkOption
      {
        type = types.listOf types.str;
        default = [ ];
      };
    traefikHost = mkOption { type = types.str; };
  };


  config = mkIf cfg.enable rec {
    virtualisation.oci-containers.containers.fava = {
      autoStart = true;
      image = cfg.image;
      ports = [ "8000" "8001:8001" "8002" ];
      volumes = [ "${toString cfg.configDir}:/bean" ];
      environment = {
        LEDGER_FILENAME = "/bean/ledger.beancount";
      };
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
      ] ++ (lib.optionals (cfg.network != "") [ "--network=${cfg.network}" ])
      ++ utils.traefikLabels
        {
          appName = "fava";
          host = cfg.traefikHost;
          port = 8000;
        } ++ [
        "-l=traefik.http.routers.fava.service=fava"
        "-l=traefik.http.routers.fava-summary.rule=Host(`fava-summary.home.tomusher.com`)"
        "-l=traefik.http.routers.fava-summary.service=fava-summary"
        "-l=traefik.http.services.fava-summary.loadbalancer.server.port=8001"
        ];
    };
  };
}
