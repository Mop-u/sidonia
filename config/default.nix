{
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./configuration.nix
        ./applications
        ./services
        ./tweaks
        ./windowManagers
    ];
}
