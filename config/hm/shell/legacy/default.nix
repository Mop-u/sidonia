{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./hyprland
        ./bemenu.nix
        ./blueman.nix
        ./dunst.nix
        ./helperPackages.nix
        ./networkManager.nix
        ./playerctld.nix
    ];
}
