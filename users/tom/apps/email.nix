{ pkgs, ... }:

let
  secrets = import ../../../secrets/secrets.nix;
in {
  imports = [
    ../../../modules/email
  ];

  usher.email = {
    enable = true;
    isyncConfig = secrets.isyncConfig;
    notmuchConfig = secrets.notmuchConfig;
    alotConfig = secrets.alotConfig;
    neomuttConfig = ./files/neomuttrc;
    googleOauthClientId = secrets.mail_google_client_id;
    googleOauthClientSecret = secrets.mail_google_client_secret;
  };
}
