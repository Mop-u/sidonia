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
        ./bemenu.nix
        ./coreServices.nix
        ./displayManager.nix
        ./gtk.nix
        ./idleLock.nix
    ];
}
