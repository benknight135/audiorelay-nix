{
  description = "Nix flake packaging AudioRelay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system:
        f system (import nixpkgs { inherit system; }));
    in {
      packages = forAllSystems (system: pkgs: {
        audiorelay = pkgs.callPackage ./default.nix { };
        default = self.packages.${system}.audiorelay;
      });
    };
}
