{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
    transparent = "rgba(255,255,255,0)";
    inherit (config.wayland.desktopManager.sidonia) window;
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
        plugins = with pkgs.hyprPlugins; [
            split-monitor-workspaces
            hyprexpo
        ];
        settings = {
            monitorv2 = lib.optional (!config.services.shikane.enable) {
                output = "";
                mode = "highres";
                position = "auto";
                scale = "auto";
            };

            execr = lib.optional config.services.shikane.enable "${config.services.shikane.package}/bin/shikane --oneshot";

            xwayland.force_zero_scaling = lib.mkDefault true;

            env = lib.mapAttrsToList (n: v: "${n},${v}") cfg.desktop.environment.hyprland;

            animations = {
                enabled = true;
                workspace_wraparound = true;
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
                active_opacity = lib.mkDefault 1.0;
                inactive_opacity = lib.mkDefault 0.95;
                rounding = lib.mkDefault window.decoration.rounding;
            };

            general = {
                border_size = lib.mkDefault window.decoration.borderWidth;
                resize_on_border = lib.mkDefault false;
                allow_tearing = lib.mkDefault true;
                layout = lib.mkDefault "scrolling";
            };

            dwindle = builtins.mapAttrs (n: v: lib.mkDefault v) {
                pseudotile = true;
                smart_split = true;
            };

            #layout.single_window_aspect_ratio = "4 3";

            scrolling = builtins.mapAttrs (n: v: lib.mkDefault v) {
                fullscreen_on_one_column = false;
                column_width = 0.5;
                explicit_column_widths = "0.333, 0.5, 0.667, 1.0"; # for colresize +conf/-conf
                direction = "right";

                follow_focus = true;
                focus_fit_method = 1; # 0 = center, 1 = fit
                follow_min_visible = 0.4;
            };

            plugin.split-monitor-workspaces = builtins.mapAttrs (n: v: lib.mkDefault v) {
                # https://github.com/zjeffer/split-monitor-workspaces
                count = 10;
                enable_wrapping = 1;
                enable_persistent_workspaces = 0;
                keep_focused = 1;
            };

            plugin.hyprexpo = builtins.mapAttrs (n: v: lib.mkDefault v) {
                # https://github.com/hyprwm/hyprland-plugins/tree/main/hyprexpo
                columns = 1;
                gap_size = 5;
                bg_col = config.wayland.windowManager.hyprland.settings.misc.background_color or "rgb(111111)";
                workspace_method = "center current";
                skip_empty = false;
                gesture_distance = 300;
            };

            render = builtins.mapAttrs (n: v: lib.mkDefault v) {
                direct_scanout = 2;
                cm_fs_passthrough = 0;
                cm_auto_hdr = 0;
            };

            misc = builtins.mapAttrs (n: v: lib.mkDefault v) {
                force_default_wallpaper = 0;
                disable_hyprland_logo = true;
                disable_splash_rendering = true;
                vrr = 1;
                mouse_move_enables_dpms = true;
                key_press_enables_dpms = true;
                render_unfocused_fps = 60;
            };

            input = builtins.mapAttrs (n: v: lib.mkDefault v) {
                kb_layout = cfg.input.keyLayout;
                # kb_variant =
                # kb_model =
                # kb_options =
                # kb_rules =
                follow_mouse = 2;
                follow_mouse_threshold = 10; # distance in logical pixels
                sensitivity = cfg.input.sensitivity;
                accel_profile = cfg.input.accelProfile;
                touchpad = {
                    natural_scroll = true;
                    scroll_factor = 0.2;
                };
            };

            cursor = builtins.mapAttrs (n: v: lib.mkDefault v) {
                no_hardware_cursors = 0;
                no_warps = true;
            };

            binds = builtins.mapAttrs (n: v: lib.mkDefault v) {
                scroll_event_delay = 10;
                drag_threshold = 10;
            };

            windowrule = [
                "match:class .*, suppress_event maximize"
                "match:class gtkwave, match:title gtkwave, float on"
            ];

            # Borderless unfocused window setup
            decoration.border_part_of_window = false;
            general."col.inactive_border" = transparent;
            group."col.border_inactive" = transparent;
            group."col.border_locked_inactive" = transparent;

        };
    };
}
