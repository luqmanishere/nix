{pkgs, ...}: {
  config = {
    colorschemes.kanagawa = {enable = true;};
    plugins = {
      barbecue.enable = true;
      gitsigns.enable = true;
      which-key.enable = true;
      rainbow-delimiters.enable = true;
      nvim-tree.enable = true;
      noice.enable = true;
      notify.enable = true;
      telescope.enable = true;
      nvim-autopairs.enable = true;
    };
    extraPlugins = with pkgs.vimPlugins; [suda-vim];
    options = {
      number = true;
      relativenumber = true;

      shiftwidth = 2;
    };
  };
}
