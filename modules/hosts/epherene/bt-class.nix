{...}: {
  flake.modules.nixos.epherene-bt = {
    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          # Enable = "Source,Sink,Media,Socket";
          Class = "0x000111";
          Experimental = true;
        };
      };
    };
  };
}
