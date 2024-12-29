{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.home-manager.url = "github:nix-community/home-manager/release-24.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs =
    { nixpkgs, home-manager, flake-utils, ... }: let
      module = ./home.nix;
    in {
      homeModules.default = module;
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;
    } // flake-utils.lib.eachDefaultSystem (system: let 
      pkgs = (import nixpkgs { inherit system; });
    in {
      homeConfigurations.test = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ module ];
      };
    });
}
