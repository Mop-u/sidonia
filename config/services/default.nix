{
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./distributedBuilds.nix
        ./dunst.nix
        ./goxlr.nix
        ./vr.nix
    ];
}
