{
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./environment.nix
        ./monitors.nix
        ./window.nix
    ];
}
