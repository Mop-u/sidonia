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
    programs.noctalia-shell.settings.desktopWidgets = builtins.mapAttrs (n: v: lib.mkDefault v) {
        enabled = false;
        gridSnap = false;
        monitorWidgets = [ ];
        overviewEnabled = true;
    };
}
