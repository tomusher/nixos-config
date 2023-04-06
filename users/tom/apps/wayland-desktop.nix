{ config, pkgs, inputs, currentSystem, ... }:
{
  imports = [
    inputs.nixos-vscode-server.nixosModules.home-manager.nixos-vscode-server
    inputs.hyprland.homeManagerModules.default
  ];

  xdg = {
    enable = true;
  };

  home.sessionVariables = {
    TERMINAL = "kitty";
    EDITOR = "nvim";

    
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";

    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;

    _JAVA_AWT_WM_NONREPARENTING = 1;
    SDL_VIDEODRIVER = "wayland";
    GDK_BACKEND = "wayland,x11";
    GTK_USE_PORTAL = 1;
  };

  home.packages = [
    pkgs.zathura
    pkgs._1password
    pkgs.firefox
    pkgs.polkit-kde-agent
    pkgs.wayvnc
    pkgs.qt5.qtwayland
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    recommendedEnvironment = true;
    extraConfig = builtins.readFile ./files/hyprland.conf;
#    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };

  programs.waybar = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.waybar-hyprland;
    style = ./files/waybar.css;
    systemd = {
      enable = true;
    };
  };
  xdg.configFile."waybar/config".text = builtins.readFile ./files/waybar.conf;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./files/kitty/kitty.conf;
    theme = "Nord";
  };
  xdg.configFile."kitty/open-actions.conf".text = builtins.readFile ./files/kitty/open-actions.conf;

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };
  xdg.configFile."rofi/config.rasi".text = builtins.readFile ./files/rofi/config.rasi;
  xdg.configFile."rofi/themes/nord.rasi".text = builtins.readFile ./files/rofi/themes/nord.rasi;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.nnn = {
    enable = true;
    plugins.mappings = {
      o = "fzopen";
      v = "imgview";
      t = "imgthumb";
      z = "autojump";
      p = "preview-tui";
      P = "preview-tabbed";
      n = "nuke";
    };
  };

  services.dunst = {
    enable = true;
  };
  xdg.configFile."dunst/dunstrc".text = builtins.readFile ./files/dunstrc;

  services.clipmenu = {
    enable = true;
  };

  programs.vscode = {
    enable = true;
  };

  services.vscode-server = {
    enable = true;
    useFhsNodeEnvironment = true;
  };
}
