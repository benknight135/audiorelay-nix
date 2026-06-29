{
  description = "Nix package for AudioRelay";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      drvSet = pkgs.callPackage ./default.nix { };
    in {
      packages.${system}.audiorelay = drvSet.audiorelay;
      packages.${system}.default = drvSet.audiorelay;
    };
}
