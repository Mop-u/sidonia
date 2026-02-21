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
        ./shell
        ./gtk.nix
        ./services.nix
    ];
}
