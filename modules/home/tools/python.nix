{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      (python3.withPackages (p: with p; [epc orjson sexpdata six setuptools paramiko rapidfuzz]))
      python3Packages.pip
    ];
  };
}
