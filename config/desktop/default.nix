{
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./common
        ./hyprland
        ./niri
        ./environment.nix
        ./monitors.nix
        ./window.nix
    ];
}
