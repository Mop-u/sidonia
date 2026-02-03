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
        ./sublimeMerge.nix
        ./sublimeText.nix
        ./surfer.nix
    ];
}
