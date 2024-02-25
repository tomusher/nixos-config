{ pkgs, lib, ... }:
let
  oauth2token = pkgs.callPackage ./oauth2token.nix {};
  cyrus-sasl-xoauth2 = pkgs.callPackage ./cyrus-sasl-xoauth2.nix {};
in pkgs.stdenv.mkDerivation rec {
  name = "email-tools";
  phases = [ "installPhase" ];
  isync-oauth2 = pkgs.buildEnv {
      name = "isync-oauth2";
      paths = [pkgs.isync];
      pathsToLink = ["/bin"];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram "$out/bin/mbsync" \
          --prefix SASL_PATH : "${pkgs.cyrus_sasl.out.outPath}/lib/sasl2:${cyrus-sasl-xoauth2}/lib/sasl2"
      '';
    };

  nativeBuildInputs = with pkgs; [ makeWrapper which isync-oauth2 alot neomutt notmuch w3m oauth2token cyrus-sasl-xoauth2 ];

  installPhase = ''
    mkdir -p $out/bin/
    cp -r ${./scripts}/* $out/
    chmod a+x $out/*
    makeWrapper $(which mbsync) $out/bin/mbsync
    makeWrapper $(which alot) $out/bin/alot
    makeWrapper $(which notmuch) $out/bin/notmuch
    makeWrapper $(which oauth2create) $out/bin/oauth2create
    makeWrapper $(which oauth2get) $out/bin/oauth2get
    makeWrapper $(which w3m) $out/bin/w3m
    makeWrapper $(which neomutt) $out/bin/neomutt
  '';

}
