{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
    tomlFormat = pkgs.formats.toml { };
    opacity = config.wayland.desktopManager.sidonia.window.decoration.opacity.dec;
in
lib.mkIf (cfg.desktop.enable) (
    lib.mkMerge [
        (lib.mkIf (cfg.desktop.shell == "noctalia-legacy") {
            programs.noctalia-shell = {
                enable = true;
                package = pkgs.noctalia-shell.override {
                    calendarSupport = osConfig.services.gnome.evolution-data-server.enable;
                };
                settings.settingsVersion = 59;
            };
        })
        (lib.mkIf (cfg.desktop.shell == "noctalia") {
            home.packages = [ pkgs.noctalia ];
            xdg.configFile."noctalia/config.toml".source = tomlFormat.generate "config.toml" {
                shell = {
                    offline_mode = false;
                    telemetry_enabled = false;
                    polkit_agent = true;
                    animation.enabled = (!cfg.graphics.legacyGpu);
                    panel.background_blur = (!cfg.graphics.legacyGpu);
                };
                wallpaper = {
                    enabled = true;
                    fill_mode = "crop";
                    transition = [ "fade" ];
                    directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
                    automation = {
                        enabled = true;
                        order = "random";
                        interval_minutes = 5;
                    };
                };
                theme = {
                    mode = "auto";
                    source = "builtin";
                    builtin = "Catppuccin";
                };
                dock.enabled = false;
                bar = {
                    order = [ "main" ];
                    main = {
                        position = "top";
                        enabled = true;
                        auto_hide = false;
                        reserve_space = true;
                        background_opacity = opacity;
                        start = [
                            "control-center"
                            "notifications"
                            "clock"
                            "sysmon"
                            "taskbar"
                        ];
                        center = [
                            "media"
                            "audio_visualizer"
                            "volume"
                        ];
                        end = [
                            "active_window"
                            "network"
                            "bluetooth"
                            "brightness"
                            "battery"
                            "tray"
                            "keyboard_layout"
                        ];
                    };
                };
            };
        })
    ]
)
