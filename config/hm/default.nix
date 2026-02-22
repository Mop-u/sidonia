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
        ./gtk.nix
        ./hyprland.nix
        ./niri.nix
        ./services.nix
    ];
}
