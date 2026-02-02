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
        ./hyprshell.nix
        ./waybar.nix
    ];
}
