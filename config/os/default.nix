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
        ./programs
        ./services
        ./tweaks
        ./configuration.nix
    ];
}
