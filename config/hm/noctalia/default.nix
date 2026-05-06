{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./v4
        ./compositorOverrides.nix
        ./keybinds.nix
        ./noctalia.nix
    ];
}
