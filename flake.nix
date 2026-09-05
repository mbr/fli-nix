{
  description = "Nix package and NixOS module for fli";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      overlay = final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (pythonFinal: _pythonPrev: {
            flights = pythonFinal.callPackage ./package.nix { };
          })
        ];
        fli = final.python3Packages.flights;
      };
    in
    {
      nixosModules.fli = import ./nixos-module.nix { inherit self; };
      nixosModules.default = self.nixosModules.fli;

      overlays.default = overlay;

      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ overlay ];
          };
        in
        {
          default = pkgs.fli;
          inherit (pkgs) fli;
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
