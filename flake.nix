{
  description = "Nix flake packaging AudioRelay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
    in {
      packages.${system} = { pkgs, ... }:
        pkgs.callPackage ./default.nix {};

      defaultPackage.${system} = self.packages.${system};
    };
}
