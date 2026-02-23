{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
in
{
    imports = [
        ./desktop
        ./programs
        ./services
        ./tweaks
        ./configuration.nix
        ./hyprland.nix
    ];
}
