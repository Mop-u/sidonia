{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
in
{
    imports = [
        ./coreServices.nix
        ./displayManager.nix
    ];
}
