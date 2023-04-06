{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    autocd = true;

    defaultKeymap = "emacs";

    history = {
      save = 100000;
      size = 100000;
      path = "${config.xdg.dataHome}/zsh/zsh_history";
    };

    initExtra = ''
      autoload edit-command-line
      zle -N edit-command-line
      bindkey "^X^E" edit-command-line

      setopt inc_append_history
      setopt extended_history
      setopt hist_ignore_dups
      setopt hist_ignore_space
      setopt hist_verify
      setopt share_history

      path+=('/home/tom/.config/Code/User/globalStorage/ms-vscode-remote.remote-containers/cli-bin')
      export PATH

      if test -n "$KITTY_INSTALLATION_DIR"; then
      export KITTY_SHELL_INTEGRATION="enabled"
      autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
      kitty-integration
      unfunction kitty-integration
      fi
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      memory_usage.disabled = true;
      gcloud.disabled = true;
    };
  };

}
