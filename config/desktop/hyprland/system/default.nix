{
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./hyprland.nix
        ./missioncenter.nix
    ];
}
