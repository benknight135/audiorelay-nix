{
  description = "Nix flake packaging AudioRelay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];
    in {
      packages = nixpkgs.lib.genAttrs systems (system:
        let 
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in {
          audiorelay = pkgs.callPackage ./default.nix { };
          default = self.packages.${system}.audiorelay;
        }
      );
    };
}
