{
    config,
    pkgs,
    lib,
    ...
}:
{
  imports = [
    ./hyprland
    ./niri
    ./dunst.nix
    ./idleLock.nix
    ./bemenu.nix
    ./coreServices.nix
  ];
}