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
    programs.noctalia-shell.settings.controlCenter = {
        position = "close_to_bar_button";
        diskPath = "/";
        shortcuts = {
            left = [
                {
                    id = "Network";
                }
                {
                    id = "Bluetooth";
                }
                {
                    id = "WallpaperSelector";
                }
                {
                    id = "NoctaliaPerformance";
                }
            ];
            right = [
                {
                    id = "Notifications";
                }
                {
                    id = "PowerProfile";
                }
                {
                    id = "KeepAwake";
                }
                {
                    id = "NightLight";
                }
            ];
        };
        cards = [
            {
                enabled = true;
                id = "profile-card";
            }
            {
                enabled = true;
                id = "shortcuts-card";
            }
            {
                enabled = true;
                id = "audio-card";
            }
            {
                enabled = false;
                id = "brightness-card";
            }
            {
                enabled = true;
                id = "weather-card";
            }
            {
                enabled = true;
                id = "media-sysmon-card";
            }
        ];
    };
}
