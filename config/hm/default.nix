{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./hyprland
        ./niri
        ./programs
        ./services
        ./gtk.nix
    ];
}
