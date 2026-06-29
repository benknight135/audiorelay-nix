{
  description = "Nix package for AudioRelay";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.audiorelay =
        (pkgs.callPackage ./default.nix { }).audiorelay;

      packages.${system}.default =
        (pkgs.callPackage ./default.nix { }).audiorelay;
    };
}
