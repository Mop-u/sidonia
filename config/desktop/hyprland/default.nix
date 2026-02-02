{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
    theme = cfg.style.catppuccin;
in
{
    imports = [ ./system ];
    home-manager.users.${cfg.userName}.imports = [ ./hm ];
}
