{...}: {
  flake.modules.homeManager.email = {pkgs, ...}: {
    programs.mbsync.enable = true;
    programs.msmtp.enable = true;
    programs.notmuch = {
      enable = true;
      hooks = {
        preNew = "${pkgs.isync}/bin/mbsync --all";
        postNew = "${pkgs.afew}/bin/afew -tn";
      };
      new.tags = ["new"];
    };
    programs.afew = {
      enable = true;
      extraConfig = ''
        [SpamFilter]
        [KillThreadsFilter]
        [SentMailsFilter]
        sent_tag = sent
        [ArchiveSentMailsFilter]

        [InboxFilter]
      '';
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

    systemd.user = {
      services.email-sync = {
        Unit = {
          Description = "Email sync";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.notmuch}/bin/notmuch new";
        };
      };
      timers.email-sync = {
        Unit = {
          Description = "Timer triggering email-sync";
        };

        Timer = {
          OnBootSec = "1min";
          OnCalendar = "*:0/05";
          Persistent = true;
          Unit = "email-sync.service";
        };

        Install.WantedBy = ["timers.target"];
      };
    };
  };
}
