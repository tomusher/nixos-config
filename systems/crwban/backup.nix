{ pkgs, ... }:

let
  secrets = import ../../secrets/secrets.nix;
  config = pkgs.substituteAll {
    src = ./autorestic.yml;
    account_id = secrets.backblaze_b2_account_id;
    account_key = secrets.backblaze_b2_account_key;
    password = secrets.restic_backups_password;

  };
  resticPackages = with pkgs; [ restic autorestic ];
in {
  environment.systemPackages = resticPackages; 

  environment.etc = {
    "autorestic/config.yml" = {
      text = builtins.readFile config.out;
      mode = "0440";
    };
    "autorestic/backup_excludes" = {
      text = builtins.readFile ./backup_excludes;
      mode = "0440";
    };
  };

  systemd.services.autorestic = {
    serviceConfig.Type = "oneshot";
    path = resticPackages;
    script = ''
      autorestic -c /etc/autorestic/config.yml cron
    '';
    startAt = "*-*-* *:0/5";
  };
}
