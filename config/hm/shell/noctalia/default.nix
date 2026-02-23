{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./settings
        ./compositorOverrides.nix
        ./keybinds.nix
        ./noctalia.nix
    ];
}
