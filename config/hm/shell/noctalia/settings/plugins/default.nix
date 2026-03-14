{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./kde-connect.nix
        ./plugins.nix
        ./workspaceOverview.nix
    ];
}
