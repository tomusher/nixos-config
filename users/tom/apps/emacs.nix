{ config, pkgs, inputs, ... }:
{
  home = {
    sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
    sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom-config";
      DOOMLOCALDIR = "${config.xdg.configHome}/doom-local";
    };
  };

  xdg = {
    enable = true;
    configFile = {
      "doom-config/config.el".source = ./files/emacs/doom/config.el;
      "doom-config/init.el".source = ./files/emacs/doom/init.el;
      "doom-config/packages.el".source = ./files/emacs/doom/packages.el;
      "emacs" = {
        source = inputs.doom-emacs;
        onChange = "${pkgs.writeShellScript "doom-change" ''
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          if [ ! -d "$DOOMLOCALDIR" ]; then
            ${config.xdg.configHome}/emacs/bin/doom -y install
          else
            ${config.xdg.configHome}/emacs/bin/doom -y sync -u
          fi
        ''}";
      };
    };
  };
}
