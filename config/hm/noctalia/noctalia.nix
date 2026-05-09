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
                weather = {
                    enabled = cfg.geolocation.enable;
                    auto_locate = cfg.geolocation.enable;
                    unit = "celsius";
                };
                shell = {
                    offline_mode = false;
                    telemetry_enabled = false;
                    polkit_agent = true;
                    animation.enabled = (!cfg.graphics.legacyGpu);
                    panel.background_blur = (!cfg.graphics.legacyGpu);
                    font_family = "monospace";
                };
                notification = {
                    enable_daemon = true;
                    background_opacity = opacity;
                };
                brightness.enable_ddcutil = true;
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
                backdrop.enabled = !cfg.graphics.legacyGpu;
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
