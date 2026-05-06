{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./plugins
        ./settings
        ./keybinds.nix
    ];
}
