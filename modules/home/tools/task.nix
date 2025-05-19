{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.tools.taskwarrior;
in {
  imports = [];

  options.modules.tools.taskwarrior = {
    enable = mkOption {
      description = "Enable taskwarrior";
      default = false;
      type = types.bool;
    };
    sync.enable = mkEnableOption "Enable sync";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      taskwarrior-tui
    ];
    programs.taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;
      colorTheme = "dark-256";
      config = {
        news.version = "2.6.0";
        default.command = "act";

        report.act = {
          description = "Unblocked tasks by project";
          columns = "id,project,priority,description.count,tags,due.relative";
          labels = "ID,Proj,Pri,Desc,Tags,Due";
          sort = "project+/,priority-,entry+";
          filter = "status:pending project!=misc -WAITING -BLOCKED -someday -notify_only";
        };

        report.booklist = {
          description = "Book list";
          columns = "id,description,tags,entry";
          labels = "ID,Desc,Tags,Entered";
          sort = "entry+";
          filter = "status:pending -WAITING -BLOCKED proj:misc.booklist";
        };

        report.next = {
          description = "What to work on next";
          columns = "id,project,description,tags";
          labels = "ID,Proj,Desc,Tags";
          filter = "+today status:pending -WAITING -BLOCKED -notify_only";
        };
      };
      extraConfig = ''
        include ${config.age.secrets.taskv3_sync.path}
      '';
    };

    # modules.secrets.taskd.enable = true;
    services.taskwarrior-sync = {
      enable = mkIf pkgs.stdenv.isLinux true;
      package = pkgs.taskwarrior3;
    };
  };
}
