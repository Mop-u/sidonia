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
        ./hyprpolkit.nix
        ./hyprshell.nix
        ./keybinds.nix
        ./waybar.nix
    ];
}
