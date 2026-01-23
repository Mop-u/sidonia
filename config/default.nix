{
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./configuration.nix
        ./programs
        ./services
        ./tweaks
        ./windowManagers
    ];
}
