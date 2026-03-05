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
            monitorv2 = [
                {
                    output = "";
                    mode = "highres";
                    position = "auto";
                    scale = "auto";
                }
            ];

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

            cursor = {
                no_hardware_cursors = 0;
                no_warps = true;
            };

            quirks.prefer_hdr = 1;

            render = {
                direct_scanout = 2; # Try turning this off if fullscreen windows/games crash instantly
                cm_sdr_eotf = 3;
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
                sensitivity = cfg.input.sensitivity;
                accel_profile = cfg.input.accelProfile;
                touchpad = {
                    natural_scroll = true;
                    scroll_factor = 0.2;
                };
            };
            windowrule = [
                "match:class .*, suppress_event maximize"

                "match:class com.saivert.pwvucontrol, match:title Pipewire Volume Control, float on"

                "match:class gtkwave, match:title gtkwave, float on"

                "match:class zenity, float on"

                "match:class nemo, float on"

                "match:class .blueman-manager-wrapped, float on"

                "match:title Open File, size ${cfg.desktop.window.decoration.float.wh}, float on"

                "match:title Save File, size ${cfg.desktop.window.decoration.float.wh}, float on"

                "match:title Select Folder, size ${cfg.desktop.window.decoration.float.wh}, float on"
            ];
        };
    };
}
