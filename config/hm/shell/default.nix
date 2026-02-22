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
        ./cursor.nix
        ./gtk.nix
        ./qt.nix
    ];
}
