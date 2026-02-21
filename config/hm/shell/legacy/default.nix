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
        ./networkManager.nix
        ./playerctld.nix
    ];
}
