{ config, pkgs, inputs, ... }:
{
  xdg = {
    enable = true;
  };

  home.packages = [
    pkgs.zathura
    pkgs._1password
    pkgs.i3status-rust
    pkgs.firefox
    pkgs.pavucontrol
  ];

  xsession.enable = true;

  xsession.windowManager.i3 = {
    package = pkgs.i3-gaps;
    enable = true;
    config = null;
    extraConfig = builtins.readFile ./files/i3;
  };
  xdg.configFile."i3status-rust/config-top.toml".text = builtins.readFile ./files/i3status-rust/config-top.toml;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.rofi = {
    enable = true;
  };
  xdg.configFile."rofi/config.rasi".text = builtins.readFile ./files/rofi/config.rasi;
  xdg.configFile."rofi/themes/nord.rasi".text = builtins.readFile ./files/rofi/themes/nord.rasi;

  services.dunst = {
    enable = true;
  };
  xdg.configFile."dunst/dunstrc".text = builtins.readFile ./files/dunstrc;

  services.clipmenu = {
    enable = true;
  };

  xresources.extraConfig = builtins.readFile ./files/Xresources;

  programs.vscode = {
    enable = true;
  };

  services.vscode-server = {
    enable = true;
    useFhsNodeEnvironment = true;
  };
}
