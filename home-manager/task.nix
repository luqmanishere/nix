{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.cli.taskwarrior;
in {
  imports = [];

  options.modules.cli.taskwarrior = {
    enable = mkOption {
      description = "Enable taskwarrior";
      default = false;
      type = types.bool;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      taskwarrior-tui
    ];
    programs.taskwarrior = {
      enable = true;
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

        taskd.certificate = "/home/luqman/.task/private.certificate.pem";
        taskd.key = "/home/luqman/.task/private.key.pem";
        taskd.ca = "/home/luqman/.task/ca.cert.pem";
        taskd.server = "inthe.am:53589";
        taskd.credentials = "inthe_am/luqmanulhakim1720/65bcddea-fc27-4af8-8cad-8582f385d4fa";
        taskd.trust = "strict";
      };
    };

    services.taskwarrior-sync.enable = true;
  };
}
