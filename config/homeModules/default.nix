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
        ./surfer.nix
    ];
}
