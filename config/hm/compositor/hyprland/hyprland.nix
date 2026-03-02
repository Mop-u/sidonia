{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
    monitors =
        builtins.map
            (
                {
                    name ? "",
                    resolution ? "highres",
                    position ? "auto",
                    scale ? null,
                    bitdepth ? null,
                    hdr ? false,
                    extraArgs ? null,
                    ...
                }:
                let
                    mode =
                        if builtins.isString resolution then
                            resolution
                        else
                            with resolution;
                            (lib.concatStringsSep "@" (
                                [
                                    (lib.concatStringsSep "x" (
                                        builtins.map (builtins.toString) [
                                            x
                                            y
                                        ]
                                    ))
                                ]
                                ++ (lib.optional (hz != null) hz)
                            ));
                    v1Args = lib.concatStringsSep ", " (
                        [
                            mode
                            position
                            (if (scale == null) then "auto" else lib.strings.floatToString scale)
                        ]
                        ++ (lib.optional (bitdepth != null) "bitdepth,${builtins.toString bitdepth}")
                        ++ (lib.optional hdr "cm,hdr")
                        ++ (lib.optional (extraArgs != null) (
                            lib.concatStringsSep "," (lib.mapAttrsToList (n: v: "${n},${v}") extraArgs)
                        ))
                    );
                in
                {
                    inherit name;
                    disable = "${name},disable";
                    v1 = "${name},${v1Args}";
                    v2 = {
                        output = name;
                        inherit mode;
                    }
                    // (lib.optionalAttrs (scale != null) { inherit scale; })
                    // (lib.optionalAttrs (position != null) { inherit position; })
                    // (lib.optionalAttrs (bitdepth != null) { bitdepth = builtins.toString bitdepth; })
                    // (lib.optionalAttrs hdr { cm = "hdr"; })
                    // (lib.optionalAttrs (extraArgs != null) extraArgs);
                }
            )
            (
                cfg.desktop.monitors
                ++ [
                    {
                        # Make sure to automatically find any unconfigured monitors
                        name = "";
                        resolution = "highres";
                        position = "auto";
                        scale = null;
                        bitdepth = null;
                        hdr = false;
                        extraArgs = null;
                    }
                ]
            );
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
        settings = {
            monitorv2 = builtins.map (mon: mon.v2) monitors;

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
                    "workspaces, 1, 6, default"
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
                layout = "dwindle";
            };

            dwindle = {
                pseudotile = true;
                smart_split = true;
            };

            cursor = {
                no_hardware_cursors = 0;
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
            bindl =
                (lib.optional cfg.isLaptop ", switch:on:Lid Switch, exec, hyprctl keyword monitor \"${(builtins.head monitors).disable}\"")
                ++ (lib.optional cfg.isLaptop ", switch:off:Lid Switch, exec, hyprctl keyword monitor \"${(builtins.head monitors).v1}\"");
        };
    };
}
