{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;

    defaultKeymap = "emacs";

    history = {
      save = 100000;
      size = 100000;
      path = "${config.xdg.dataHome}/zsh/zsh_history";
    };

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

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

      export PATH

      if test -n "$KITTY_INSTALLATION_DIR"; then
      export KITTY_SHELL_INTEGRATION="enabled"
      autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
      kitty-integration
      unfunction kitty-integration
      fi
      function set_win_title(){
        echo -ne "\033]0; $PWD \007"
      }
      precmd_functions+=(set_win_title)
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
