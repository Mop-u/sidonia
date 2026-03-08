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
lib.mkIf (cfg.desktop.enable && (cfg.desktop.compositor == "hyprland")) {
    assertions = [
        {
            assertion = !cfg.graphics.legacyGpu;
            message = "Hyprland no longer supports the legacy renderer for old GPUs.";
        }
    ];

    home.packages = [
        pkgs.hypridle
        pkgs.hyprshot
    ];

    xdg.configFile."hypr/xdph.conf".text = ''
        screencopy {
            max_fps = 60
            allow_token_by_default = true
        }
    '';

    wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = false;
        systemd.enableXdgAutostart = false;
        xwayland.enable = true;
        plugins = [ pkgs.split-monitor-workspaces ];
        settings = {
            monitorv2 = lib.optional (!config.services.shikane.enable) {
                output = "";
                mode = "highres";
                position = "auto";
                scale = "auto";
            };

            execr = lib.optional config.services.shikane.enable "${config.services.shikane.package}/bin/shikane --oneshot";

            xwayland = {
                force_zero_scaling = true;
            };

            env = lib.mapAttrsToList (n: v: "${n},${v}") cfg.desktop.environment.hyprland;

            animations = {
                enabled = true;
                bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
                animation = [
                    "windows, 1, 7, myBezier"
                    "windowsOut, 1, 7, default, popin 80%"
                    "border, 1, 10, default"
                    "borderangle, 1, 8, default"
                    "fade, 1, 7, default"
                    "workspaces, 1, 6, default, slidevert"
                ];
            };

            decoration = {
                active_opacity = 1.0;
                inactive_opacity = 0.95;
            };

            general = {
                border_size = cfg.desktop.window.decoration.borderWidth;
                resize_on_border = false;
                allow_tearing = true;
                layout = "scrolling";
            };

            dwindle = {
                pseudotile = true;
                smart_split = true;
            };

            layout.single_window_aspect_ratio = "4 3";

            scrolling = {
                fullscreen_on_one_column = true;
                column_width = 0.5;
                focus_fit_method = 1; # 0 = center, 1 = fit
                follow_focus = true;
                follow_min_visible = 0.4;
                explicit_column_widths = "0.333, 0.5, 0.667, 1.0"; # for colresize +conf/-conf
                direction = "right";
            };

            plugin.split-monitor-workspaces = {
                # https://github.com/zjeffer/split-monitor-workspaces
                count = 10;
                enable_wrapping = 1;
                enable_persistent_workspaces = 0;
                keep_focused = 1;
            };

            quirks.prefer_hdr = 1;

            render = {
                direct_scanout = 2;
            };

            misc = {
                force_default_wallpaper = 0;
                disable_hyprland_logo = true;
                vrr = 1;
                mouse_move_enables_dpms = true;
                key_press_enables_dpms = true;
                render_unfocused_fps = 60;
            };

            input = {
                kb_layout = cfg.input.keyLayout;
                # kb_variant =
                # kb_model =
                # kb_options =
                # kb_rules =
                follow_mouse = 1;
                follow_mouse_threshold = 10; # distance in logical pixels
                sensitivity = cfg.input.sensitivity;
                accel_profile = cfg.input.accelProfile;
                touchpad = {
                    natural_scroll = true;
                    scroll_factor = 0.2;
                };
            };

            cursor = {
                no_hardware_cursors = 0;
                no_warps = true;
            };

            binds = {
                scroll_event_delay = 10;
                drag_threshold = 10;
            };

            windowrule = [
                "match:class .*, suppress_event maximize"

                "match:class gtkwave, match:title gtkwave, float on"
            ];
        };
    };
}
