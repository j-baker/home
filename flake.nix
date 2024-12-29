{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.home-manager.url = "github:nix-community/home-manager/release-24.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs =
    {
      nixpkgs,
      home-manager,
      flake-utils,
      ...
    }:
    let
      module = ./home.nix;
    in
    {
      lib.home-manager = home-manager;
      homeModules.default = module;
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = (import nixpkgs { inherit system; });
      in
      {
        formatter = pkgs.nixfmt-rfc-style;
        checks.canBuild =
          (home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            modules = [
              module
            ];
          }).activationPackage;
      }
    );
}
