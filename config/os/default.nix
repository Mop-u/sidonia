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
        ./hyprland
        ./niri
        ./programs
        ./services
        ./tweaks
        ./configuration.nix
    ];
}
