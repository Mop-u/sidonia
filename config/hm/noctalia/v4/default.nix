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
        ./noctalia.nix
    ];
}
