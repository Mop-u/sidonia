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
        ./keybinds.nix
    ];
}
