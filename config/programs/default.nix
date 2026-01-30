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
        ./vscodium.nix
        ./zsh.nix
    ];
    home-manager.users.${cfg.userName}.imports = [
        ./sublime4.nix
    ];
}
