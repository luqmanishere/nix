_: {
  config = {
    globals = {
      mapleader = " ";
      maplocalleader = ",";
    };
    keymaps = [
      ##### quit commands
      {
        action = "<cmd>qa<CR>";
        key = "<leader>q";
        mode = "n";
        options.desc = "Quit";
      }
      ##### write commands
      {
        action = "<cmd>SudaWrite<CR>";
        key = "<leader>W";
        mode = "n";
        options = {desc = "Write with sudo";};
      }
      {
        action = "<cmd>w<CR>";
        key = "<leader>w";
        mode = "n";
        options.desc = "Save current file";
      }
      #### insert mode
      {
        # use kj to return to normal mode
        action = "<Esc>";
        key = "kj";
        mode = "i";
      }

      {
        action = "<cmd>Telescope find_files<CR>";
        key = "<leader>ff";
        mode = "n";
        options.desc = "Find files with Telescope";
      }
      {
        action = "<cmd>NvimTreeToggle<CR>";
        key = "<leader>o";
        mode = "n";
        options.desc = "Open (or close) nvim-tree";
      }
      {
        action = "<cmd>NvimTreeFocus<CR>";
        key = "<leader>e";
        mode = "n";
        options.desc = "Move focus to NvimTree";
      }

      {
        action = "<cmd>Telescope buffers<CR>";
        key = "<leader>bb";
        mode = "n";
        options.desc = "Switch buffer";
      }
    ];
  };
}
