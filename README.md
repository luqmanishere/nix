# NixOS configuration

## WIP Fresh Install

1. Install minimal profile

2. Setup impermeanance (if used)

3. Setup secureboot keys (if used)

```bash
sudo sbctl create-keys
```

## To Install

```bash
git clone https://github.com/luqmanishere/nix
cd nix

# enable flakes temporarily
export NIX_CONFIG="experimental-features = nix-command flakes"

# tweak to satisfaction
# for home-manager only
nix run nixpkgs#home-manager switch --flake .#user@hostname

# for NixOS
sudo nixos-rebuild switch --flake .#hostname
```

## Machine names:

- asuna - Honor MagicBook Pro
- kurumi - VirtualBox VM
