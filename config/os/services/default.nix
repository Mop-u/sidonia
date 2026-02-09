{
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./coreServices.nix
        ./displayManager.nix
        ./distributedBuilds.nix
        ./goxlr.nix
        ./vr.nix
    ];
}
