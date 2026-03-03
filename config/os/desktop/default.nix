{
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./environment.nix
        ./window.nix
    ];
}
