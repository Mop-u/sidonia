{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
in
lib.mkIf (cfg.desktop.enable) {
    home-manager.users.${cfg.userName}.programs.floorp = {
        enable = true;
        #profiles.default.packages = [];
    };
}
