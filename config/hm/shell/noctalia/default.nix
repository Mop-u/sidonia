{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./hyprland.nix
        ./niri.nix
        ./noctalia.nix
    ];
}
