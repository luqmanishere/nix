{pkgs, ...}: {
  config = {
    programs.pidgin = {
      enable = true;
      plugins = [];
    };
  };
}
