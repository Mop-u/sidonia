{
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./sidonia
        ./bemenu.nix
        ./discord.nix
        ./gtkwave.nix
        ./hyprland.nix
        ./sublimeMerge.nix
        ./sublimeText.nix
        ./surfer.nix
    ];
}
