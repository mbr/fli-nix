# fli-nix

Nix packaging and a NixOS module for [fli](https://github.com/punitarani/fli).

The flake exposes `packages.<system>.fli`, `packages.<system>.default`, `overlays.default`, and `nixosModules.default`.

```nix
inputs.fli-nix = {
  url = "git+ssh://git@github.com/mbr/fli-nix.git";
  inputs.nixpkgs.follows = "nixpkgs";
};
```
