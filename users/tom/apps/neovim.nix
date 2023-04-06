{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-nix
      telescope-nvim
      telescope-zoxide
      nord-nvim
      nvim-treesitter
      nvim-lspconfig
    ];

    extraConfig = ''
      set mouse=a
      set mousehide

      set virtualedit=onemore
      set history=1000
      set spell

      set undofile
      set undolevels=1000
      set undoreload=10000

      set cursorline
      set number
      set showmatch

      set ignorecase
      set smartcase
      set gdefault

      set nowrap
      set shiftwidth=4
      set expandtab
      set tabstop=4
      set softtabstop=4

      set t_Co=256
      colorscheme nord

      lua <<EOF
      	require'lspconfig'.terraformls.setup{}
      EOF
      autocmd BufWritePre *.tf lua vim.lsp.buf.formatting_sync()
    '';

  };
}
