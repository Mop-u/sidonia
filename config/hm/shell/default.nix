{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./noctalia
        ./bemenu.nix
        ./cursor.nix
        ./gtk.nix
        ./qt.nix
    ];
}
