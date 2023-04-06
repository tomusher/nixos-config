{ config, lib, pkgs, osConfig, ... }:

with lib;
let
  cfg = config.usher.email;
  hmConfig = config;
  email = pkgs.callPackage ./email.nix { };
in
rec {
  options.usher.email = {
    enable = mkOption { type = types.bool; default = false; };
    isyncConfig = mkOption { type = types.path; };
    notmuchConfig = mkOption { type = types.path; };
    alotConfig = mkOption { type = types.path; };
    googleOauthClientId = mkOption { type = types.str; };
    googleOauthClientSecret = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable rec {
    home.packages = with pkgs; [ email ];
    xdg.configFile."mbsync/mbsyncrc".source = cfg.isyncConfig;
    xdg.configFile."notmuch/config".source = cfg.notmuchConfig;
    xdg.configFile."alot/config".source = cfg.alotConfig;
    xdg.configFile."oauth2token/google/config.json".source = pkgs.substituteAll {
        src = ./oauth2token/config.json;
        oauth_client_id = cfg.googleOauthClientId;
        oauth_client_secret = cfg.googleOauthClientSecret;
    };
    xdg.configFile."oauth2token/google/scopes.json".text = builtins.readFile ./oauth2token/scopes.json;

    home.sessionVariables."NOTMUCH_CONFIG" = "${hmConfig.xdg.configHome}/notmuch/config";

    systemd.user.services.mbsync-run = {
        Unit = {
            Description = "Sync mail with mbsync";
        };
        Service = {
            Type = "oneshot";
            ExecStartPre = "${email}/notmuch-move.sh";
            ExecStart = "${email}/bin/mbsync --config ${hmConfig.xdg.configHome}/mbsync/mbsyncrc all";
            ExecStartPost = [ "${email}/bin/notmuch new" "${email}/notmuch-tag.sh" "${email}/notmuch-notify.sh" ];
            Environment = [
                "NOTMUCH_CONFIG=${hmConfig.xdg.configHome}/notmuch/config"
                "PATH=${lib.makeBinPath [pkgs.bash pkgs.coreutils pkgs.gnugrep pkgs.findutils email]}"
            ];
        };
    };
  };

}
