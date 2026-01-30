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
        ./sublime.nix
        ./vscodium.nix
        ./zsh.nix
    ];
}
