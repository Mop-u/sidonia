{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./compositor
        ./noctalia
        ./programs
        ./gtk.nix
        ./pointerCursor.nix
        ./qt.nix
        ./services.nix
    ];
}
