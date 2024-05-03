{pkgs, ...}: {
  config = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin
        {
          name = "windline";
          src = pkgs.fetchFromGitHub {
            owner = "windwp";
            repo = "windline.nvim";
            rev = "54401a62c61d56fe9df106321b158c9048aa5f9b";
            hash = "sha256-95hsm+1dKKnW9jW8yAaF7r/ESB12qugGXzJ/IjbrOxU=";
          };
        })
    ];
    extraConfigLua = ''
      require('wlsample.wind')
    '';
  };
}
