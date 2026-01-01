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
        ./coreServices.nix
        ./bemenu.nix
    ];
}
