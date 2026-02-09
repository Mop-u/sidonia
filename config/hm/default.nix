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
        ./programs
        ./services
        ./gtk.nix
    ];
}
