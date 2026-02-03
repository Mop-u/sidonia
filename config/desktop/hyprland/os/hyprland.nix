{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
in
lib.mkIf (cfg.desktop.enable && (cfg.desktop.compositor == "hyprland")) {
    programs.hyprland = {
        enable = true;
        withUWSM = true;
    };
}
