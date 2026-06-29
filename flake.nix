{
  description = "Nix flake packaging AudioRelay";

  inputs = {
    nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];
    in {
      packages = nixpkgs.lib.genAttrs systems (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          audiorelay = pkgs.callPackage ./default.nix { };
          default = self.packages.${system}.audiorelay;
        }
      );
    };
}
