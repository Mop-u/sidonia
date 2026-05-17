{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
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
            programs.noctalia = {
                enable = true;
                systemd.enable = lib.mkDefault true;
                settings = {
                    weather = lib.mapAttrs (n: v: lib.mkDefault v) {
                        enabled = cfg.geolocation.enable;
                        auto_locate = cfg.geolocation.enable;
                        unit = "celsius";
                    };
                    shell = lib.mapAttrs (n: v: lib.mkDefault v) {
                        offline_mode = false;
                        telemetry_enabled = false;
                        polkit_agent = true;
                        animation.enabled = (!cfg.graphics.legacyGpu);
                        panel.background_blur = (!cfg.graphics.legacyGpu);
                        font_family = "monospace";
                        shadow.blur = 0;
                    };
                    notification = lib.mapAttrs (n: v: lib.mkDefault v) {
                        enable_daemon = true;
                        background_opacity = opacity;
                    };
                    brightness.enable_ddcutil = lib.mkDefault true;
                    wallpaper = {
                        enabled = lib.mkDefault true;
                        fill_mode = lib.mkDefault "crop";
                        transition = [ "fade" ];
                        directory = lib.mkDefault "${config.home.homeDirectory}/Pictures/Wallpapers";
                        automation = lib.mapAttrs (n: v: lib.mkDefault v) {
                            enabled = true;
                            order = "random";
                            interval_minutes = 15;
                        };
                    };
                    backdrop.enabled = lib.mkDefault (!cfg.graphics.legacyGpu);
                    dock = lib.mapAttrs (n: v: lib.mkDefault v) {
                        enabled = false;
                        shadow = false;
                    };
                    bar = {
                        order = [ "main" ];
                        main = lib.mapAttrs (n: v: lib.mkDefault v) {
                            shadow = false;
                            position = "top";
                            enabled = true;
                            auto_hide = false;
                            reserve_space = true;
                            background_opacity = opacity;
                            margin_ends = 16;
                            margin_edge = 8;
                            widget_spacing = 8;
                            capsule = true;
                            start = [
                                "control-center"
                                "notifications"
                                "clock"
                                "taskbar"
                            ];
                            center = [
                                "active_window"
                            ];
                            end = [
                                "media"
                                "volume"
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
            };
        })
    ]
)
