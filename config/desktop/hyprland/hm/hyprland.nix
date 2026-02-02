{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
    theme = cfg.style.catppuccin;
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

    catppuccin.hyprland.enable = false;

    services.hyprpolkitagent.enable = true;

    home.packages = [
        pkgs.hypridle
        pkgs.hyprcursor
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
        settings =
            let
                shadow_opacity = "55";
                color = theme.color // {
                    shadow = "000000";
                };
                rgb = lib.mapAttrs (n: v: "rgb(${v})") color;
                rgba = lib.mapAttrs (n: v: (alpha: "rgba(${v}${alpha})")) color;
            in
            {
                monitorv2 = builtins.map (mon: mon.v2) monitors;

                xwayland = {
                    force_zero_scaling = true;
                };

                env = lib.mapAttrsToList (n: v: "${n},${v}") cfg.desktop.environment.hyprland;

                # Gradients:
                general."col.active_border" = rgb.accent; # border color for the active window
                general."col.inactive_border" = rgb.overlay2; # border color for inactive windows
                general."col.nogroup_border_active" = rgb.maroon; # active border color for window that cannot be added to a group (see denywindowfromgroup dispatcher)
                general."col.nogroup_border" = rgb.overlay2; # inactive border color for window that cannot be added to a group (see denywindowfromgroup dispatcher)

                group."col.border_active" = rgb.flamingo; # active group border color
                group."col.border_inactive" = rgb.overlay2; # inactive (out of focus) group border color
                group."col.border_locked_active" = "${rgb.flamingo} ${rgb.accent} 45deg"; # active locked group border color
                group."col.border_locked_inactive" = rgb.overlay2; # inactive locked group border color

                group.groupbar."col.active" = rgb.flamingo; # active group border color
                group.groupbar."col.inactive" = rgb.overlay2; # inactive (out of focus) group border color
                group.groupbar."col.locked_active" = "${rgb.flamingo} ${rgb.accent} 45deg"; # active locked group border color
                group.groupbar."col.locked_inactive" = rgb.overlay2; # inactive locked group border color

                # Colours:
                group.groupbar.text_color = rgb.text; # controls the group bar text color
                misc."col.splash" = rgb.text; # Changes the color of the splash text (requires a monitor reload to take effect).
                misc.background_color = rgb.crust; # change the background color. (requires enabled disable_hyprland_logo)

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
                    rounding = cfg.desktop.window.decoration.rounding;
                    active_opacity = 1.0;
                    inactive_opacity = 1.0;
                    shadow = {
                        enabled = true;
                        range = 12;
                        render_power = 3;
                        color = rgba.shadow shadow_opacity; # shadow's color. Alpha dictates shadow's opacity.
                    };
                    blur = {
                        enabled = true;
                        size = 3;
                        passes = 1;
                        vibrancy = 0.1696;
                    };
                };

                general = {
                    gaps_in = 5;
                    gaps_out = 20;
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
                    enable_hyprcursor = true;
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
                    "match:xwayland 1, match:focus 0, border_color ${rgb.overlay2}"
                    "match:xwayland 1, match:focus 1, border_color ${rgb.yellow}"

                    "match:class com.saivert.pwvucontrol, match:title Pipewire Volume Control, float on"

                    "match:class gtkwave, match:title gtkwave, float on"

                    "match:class zenity, float on"

                    "match:class nemo, float on"

                    "match:class .blueman-manager-wrapped, float on"

                    "match:title Open File, size ${cfg.desktop.window.decoration.float.wh}, float on"

                    "match:title Save File, size ${cfg.desktop.window.decoration.float.wh}, float on"

                    "match:title Select Folder, size ${cfg.desktop.window.decoration.float.wh}, float on"
                ];
                gesture = [ "3, horizontal, workspace" ];
                binds = {
                    scroll_event_delay = 100;
                };
                bindel = [
                    ", XF86AudioRaiseVolume,  exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@   5%+"
                    ", XF86AudioLowerVolume,  exec, wpctl set-volume      @DEFAULT_AUDIO_SINK@   5%-"
                    ", XF86AudioMute,         exec, wpctl set-mute        @DEFAULT_AUDIO_SINK@   toggle"
                    ", XF86AudioMicMute,      exec, wpctl set-mute        @DEFAULT_AUDIO_SOURCE@ toggle"
                    ", XF86MonBrightnessUp,   exec, brightnessctl s 10%+"
                    ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
                ];
                bindl = [
                    ", XF86AudioNext,  exec, playerctl next"
                    ", XF86AudioPause, exec, playerctl play-pause"
                    ", XF86AudioPlay,  exec, playerctl play-pause"
                    ", XF86AudioPrev,  exec, playerctl previous"
                ]
                ++ (lib.optional cfg.isLaptop ", switch:on:Lid Switch, exec, hyprctl keyword monitor \"${(builtins.head monitors).disable}\"")
                ++ (lib.optional cfg.isLaptop ", switch:off:Lid Switch, exec, hyprctl keyword monitor \"${(builtins.head monitors).v1}\"");
                binde = [
                    "SUPERALT,   H,         resizeactive, -10    0" # resize left
                    "SUPERALT,   J,         resizeactive,   0   10" # resize down
                    "SUPERALT,   K,         resizeactive,   0  -10" # resize up
                    "SUPERALT,   L,         resizeactive,  10    0" # resize right
                ];
                bind =
                    (builtins.map (
                        x: "${lib.concatStrings x.mod}, ${x.key}, exec, uwsm app -- ${x.exec}"
                    ) cfg.desktop.keybinds)
                    ++ [
                        "SUPERSHIFT, C,         killactive,"
                        "SUPERSHIFT, Q,         exec, uwsm stop"
                        "SUPER,      V,         togglefloating,"
                        "SUPER,      F,         fullscreen,"
                        "SUPER,      H,         movefocus, l"
                        "SUPER,      J,         movefocus, d"
                        "SUPER,      K,         movefocus, u"
                        "SUPER,      L,         movefocus, r"
                        "SUPERSHIFT, H,         swapwindow, l"
                        "SUPERSHIFT, J,         swapwindow, d"
                        "SUPERSHIFT, K,         swapwindow, u"
                        "SUPERSHIFT, L,         swapwindow, r"
                        "SUPER,      mouse_down,workspace, e+1"
                        "SUPER,      mouse_up,  workspace, e-1"
                        "SUPER,      S,         togglespecialworkspace, magic"
                        "SUPERSHIFT, S,         movetoworkspace,        special:magic"
                        ",           PRINT,     exec, hyprshot -m output -m active --clipboard-only" # screenshot active monitor
                        "SUPER,      PRINT,     exec, hyprshot -m window -m active --clipboard-only" # screenshot active window
                        "SUPERSHIFT, PRINT,     exec, hyprshot -m region --clipboard-only" # screenshot region
                    ]
                    ++ (builtins.concatLists (
                        builtins.genList (
                            x:
                            let
                                ws =
                                    let
                                        c = (x + 1) / 10;
                                    in
                                    builtins.toString (x + 1 - (c * 10));
                            in
                            [
                                "SUPER,          ${ws},workspace,             ${builtins.toString (x + 1)}"
                                "SUPERSHIFT,     ${ws},movetoworkspace,       ${builtins.toString (x + 1)}"
                                "SUPERCONTROL,   ${ws},movetoworkspacesilent, ${builtins.toString (x + 1)}"
                                "SUPERCONTROLALT,${ws},moveworkspacetomonitor,${builtins.toString (x + 1)} current"
                                "SUPERCONTROLALT,${ws},workspace,             ${builtins.toString (x + 1)}"
                            ]
                        ) 10
                    ));
                bindm = [
                    "SUPER, mouse:272, movewindow"
                    "SUPER, mouse:273, resizewindow"
                ];
            };
    };
}
