nixvim:
{ ... }:
{
  imports = [
    ./home.nix
    nixvim.homeManagerModules.nixvim
  ];
}
