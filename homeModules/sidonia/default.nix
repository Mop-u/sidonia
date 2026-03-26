{
    osConfig,
    config,
    lib,
    pkgs,
    ...
}:
{
    imports = [
        ./environment.nix
        ./keybinds.nix
        ./window.nix
    ];
}
