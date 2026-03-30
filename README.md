# NixOS configuration
Refactored to dendritic configurations.

I see the appeal, but it is a lot of brainpower trying to divide features.

## To Install

```bash
git clone https://github.com/luqmanishere/nix
cd nix

# enable flakes temporarily
export NIX_CONFIG="experimental-features = nix-command flakes"

# tweak to satisfaction

# switch for NixOS
sudo nixos-rebuild switch --flake .#hostname

# or, to install
nixos-install --root /mnt --flake .#hostname
```

## (Maintained) Machine names:

- sinon - Honor MagicBook Art 14 (NixOS-WSL)

# Old, Irrelevant details
## WIP Fresh Install

1. Install minimal profile

2. Setup impermeanance (if used)

3. Setup secureboot keys (if used)

```bash
sudo sbctl create-keys
```


