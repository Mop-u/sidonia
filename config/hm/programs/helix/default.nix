{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./helix.nix
    ./verilog.nix
    ./haskell.nix
  ];
}
