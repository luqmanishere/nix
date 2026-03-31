{...}: {
  flake.modules.homeManager.email = {...}: {
    programs.mbsync.enable = true;
    programs.msmtp.enable = true;
    programs.notmuch = {
      enable = true;
      hooks = {preNew = "mbsync --all";};
    };

    accounts.email = {
      accounts.personal = {
        enable = true;
        address = "luqmanulhakim1720@gmail.com";
        primary = true;
        imap.host = "imap.gmail.com";
        mbsync = {
          enable = true;
          create = "maildir";
        };
        msmtp.enable = true;
        notmuch.enable = true;
        realName = "Luqmanul Hakim";
        smtp = {
          host = "smtp.gmail.com";
        };
        userName = "luqmanulhakim1720@gmail.com";
        passwordCommand = "pass show email/main-mbsync";
      };
    };
  };
}
