{ pkgs, ... }:
let
  secrets = import ../../../secrets/secrets.nix;
  config = pkgs.substituteAll {
    src = ./autorestic.yml;
    account_id = secrets.backblaze_b2_account_id;
    account_key = secrets.backblaze_b2_account_key;
    password = secrets.restic_backups_password;

  };
  autorestic = pkgs.autorestic.overrideAttrs (o: {
    patches = (o.patches or [ ]) ++ [
      ./autorestic.patch
    ];
  });
in pkgs.stdenv.mkDerivation rec {
  name = "backup-cron";
  phases = [ "installPhase" ];
  bin = pkgs.writeShellApplication {
    name = name;
    runtimeInputs = with pkgs; [ bash autorestic restic ];
    text = ''
      autorestic -c autorestic.yml cron
    '';
  };

  nativeBuildInputs = with pkgs; [ makeWrapper autorestic restic which ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${bin}/bin/backup-cron $out/bin/backup-cron
    cp ${config} $out/autorestic.yml
    cp ${./backup_excludes} $out/backup_excludes
    substituteInPlace $out/autorestic.yml --replace backup_excludes $out/backup_excludes
    substituteInPlace $out/bin/backup-cron --replace autorestic.yml $out/autorestic.yml
    makeWrapper $(which restic) $out/bin/restic
    makeWrapper $(which autorestic) $out/bin/autorestic
  '';

}
