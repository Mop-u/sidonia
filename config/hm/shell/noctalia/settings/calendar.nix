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
    programs.noctalia-shell.settings.calendar = builtins.mapAttrs (n: v: lib.mkDefault v) {
        cards = [
            {
                enabled = true;
                id = "calendar-header-card";
            }
            {
                enabled = true;
                id = "calendar-month-card";
            }
            {
                enabled = true;
                id = "weather-card";
            }
        ];
    };
}
