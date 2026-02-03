{
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./hyprland.nix
        ./pam.nix
    ];
}
