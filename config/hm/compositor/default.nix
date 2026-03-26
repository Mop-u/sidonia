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
        ./niri.nix
        ./keybinds.nix
    ];
}
