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
    programs.noctalia-shell = {
        enable = true;
        package = pkgs.noctalia-shell.override {
            calendarSupport = osConfig.services.gnome.evolution-data-server.enable;
        };
        settings.settingsVersion = 53;
    };
}
