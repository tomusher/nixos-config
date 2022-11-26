{ pkgs, ... }:

let
  secrets = import ../../secrets/secrets.nix;
  backup-cron = import ./backup-cron/default.nix { inherit pkgs; };
  backupPackages = with pkgs; [ backup-cron ];
in {
  environment.systemPackages = backupPackages; 

  systemd.services.autorestic = {
    serviceConfig.Type = "oneshot";
    path = backupPackages;
    script = ''
      backup-cron
    '';
    startAt = "*-*-* *:0/5";
  };
}
