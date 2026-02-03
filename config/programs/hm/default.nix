{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./defaultApps.nix
        ./floorp.nix
        ./gtkwave.nix
        ./sublime.nix
        ./vscodium.nix
        ./zsh.nix
    ];
}
