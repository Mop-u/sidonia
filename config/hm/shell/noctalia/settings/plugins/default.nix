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
        ./screen-recorder.nix
        ./workspaceOverview.nix
    ];
}
