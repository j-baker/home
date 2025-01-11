{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.home-manager.url = "github:nix-community/home-manager/release-24.11";
  inputs.nixvim.url = "github:nix-community/nixvim";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs =
    {
      nixpkgs,
      home-manager,
      flake-utils,
      nixvim,
      ...
    }:
    let
      module = (import ./base.nix) nixvim;
    in
    {
      lib.home-manager = home-manager;
      homeModules.default = module;
      homeConfigurations.macos = home-manager.lib.homeManagerConfiguration {
        pkgs = (import nixpkgs { system = "aarch64-darwin"; });
        modules = [ module ];

        extraSpecialArgs = {
          username = "james";
          homeDirectory = "/Users/james";
          email = "j.baker@outlook.com";
        };
      };
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

            extraSpecialArgs = {
              username = "james";
              homeDirectory = "/Users/james";
              email = "j.baker@outlook.com";
            };
          }).activationPackage;
      }
    );
}
