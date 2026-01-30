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
        ./foot.nix
        ./system
    ];
    home-manager.users.${cfg.userName}.imports = [
        ./hm
    ];
}
