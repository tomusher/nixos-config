{ config, pkgs, inputs, ... }:
{
  imports = [
    ./zsh.nix
    ./neovim.nix
  ];

  home.stateVersion = "22.05";

  nixpkgs.config.allowUnfree = true;

  home.packages = [
  ];

  home.sessionVariables = {
    TERMINAL = "kitty";
    EDITOR = "nvim";
  };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./files/kitty/kitty.conf;
    theme = "Nord";
  };
  xdg.configFile."kitty/open-actions.conf".text = builtins.readFile ./files/kitty/open-actions.conf;

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


  programs.git = {
    enable = true;
    userName = "Tom Usher";
    userEmail = "tom@tomusher.com";
  };
}
