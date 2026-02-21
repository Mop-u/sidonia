{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./legacy
        ./noctalia
    ];
}
