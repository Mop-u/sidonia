{
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./sidonia
        ./discord.nix
        ./gtkwave.nix
        ./hyprland.nix
        ./sublimeMerge.nix
        ./sublimeText.nix
        ./surfer.nix
    ];
}
