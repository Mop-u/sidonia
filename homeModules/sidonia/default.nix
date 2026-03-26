{
    osConfig,
    config,
    lib,
    pkgs,
    ...
}:
{
    imports = [
        ./keybinds.nix
        ./window.nix
    ];
}
