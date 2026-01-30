{
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./discord.nix
        ./gtkwave.nix
        ./sublimeMerge.nix
        ./sublimeText.nix
        ./surfer.nix
    ];
}
