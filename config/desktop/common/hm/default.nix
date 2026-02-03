{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./bemenu.nix
        ./gtk.nix
    ];
}
