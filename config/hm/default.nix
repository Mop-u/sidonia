{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./programs
        ./shell
        ./hyprland.nix
        ./niri.nix
        ./services.nix
    ];
}
