{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
in
lib.mkIf (cfg.desktop.enable && (cfg.desktop.compositor == "niri")) {
    programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
    };
}
