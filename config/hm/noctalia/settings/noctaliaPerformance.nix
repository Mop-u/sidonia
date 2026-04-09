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
lib.mkIf (cfg.desktop.enable && (cfg.desktop.shell == "noctalia")) {
    programs.noctalia-shell.settings.noctaliaPerformance = builtins.mapAttrs (n: v: lib.mkDefault v) {
        disableDesktopWidgets = true;
        disableWallpaper = true;
    };
}
