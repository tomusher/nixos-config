{ config, pkgs, inputs, ... }:
{
  imports = [
    ./zsh.nix
    ./neovim.nix
    inputs.nixos-vscode-server.nixosModules.home-manager.nixos-vscode-server
  ];

  home.stateVersion = "22.05";

  xdg = {
    enable = true;
  };

  home.sessionVariables = {
    TERMINAL = "kitty";
    EDITOR = "nvim";
  };

  home.packages = [
    pkgs.ripgrep
    pkgs.fd
    pkgs.jq
    pkgs.zathura
    pkgs._1password
    pkgs.i3status-rust
    pkgs.firefox
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

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./files/kitty/kitty.conf;
    theme = "Nord";
  };
  xdg.configFile."kitty/open-actions.conf".text = builtins.readFile ./files/kitty/open-actions.conf;

  programs.rofi = {
    enable = true;
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

  xresources.extraConfig = builtins.readFile ./files/Xresources;

  programs.vscode = {
    enable = true;
  };

  services.vscode-server = {
    enable = true;
    useFhsNodeEnvironment = true;
  };

  programs.git = {
    enable = true;
    userName = "Tom Usher";
    userEmail = "tom@tomusher.com";
  };
}
