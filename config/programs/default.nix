{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
in
{
    imports = [
        ./defaultApps.nix
        ./floorp.nix
        ./foot.nix
        ./steam.nix
        ./sublime4.nix
        ./vscodium.nix
        ./zsh.nix
    ];
}
