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
        ./hyprlock.nix
        ./hyprshell.nix
        ./keybinds.nix
        ./waybar.nix
    ];
}
