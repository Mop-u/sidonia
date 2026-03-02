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
        ./keybinds.nix
    ];
}
