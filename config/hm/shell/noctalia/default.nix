{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./settings
        ./hyprland.nix
        ./keybinds.nix
        ./niri.nix
        ./noctalia.nix
    ];
}
