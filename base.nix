modules:
{ ... }:
{
  imports = [
    ./home.nix
  ] ++ modules;
}
