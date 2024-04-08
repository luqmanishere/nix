{...}: {
  config = {
    nixpkgs = {
      config = {
        allowUnfree = true;
        # Workaround for https://github.com/nix-community/home-manager/issues/2942
        allowUnfreePredicate = _: true;
        permittedInsecurePackages = ["electron-11.5.0" "electron-25.9.0"];
      };
    };
  };
}
