{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
    theme = cfg.style.catppuccin;
in
{
    imports = [
        ./hyprland.nix
        ./waybar.nix
        ./hyprshell.nix
    ];
}
