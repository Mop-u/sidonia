{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
in
lib.mkIf (cfg.desktop.enable) {
    programs.floorp = {
        enable = lib.mkDefault true;
        #profiles.default.packages = [];
    };
}
