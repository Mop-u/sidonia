{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./hypridle.nix
        ./hyprland.nix
        ./hyprshell.nix
        ./waybar.nix
    ];
}
