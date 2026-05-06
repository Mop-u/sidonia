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
lib.mkIf (cfg.desktop.enable && (cfg.desktop.shell == "noctalia-legacy")) {
    programs.noctalia-shell.settings.desktopWidgets = builtins.mapAttrs (n: v: lib.mkDefault v) {
        enabled = false;
        gridSnap = false;
        gridSnapScale = false;
        monitorWidgets = [ ];
        overviewEnabled = true;
    };
}
