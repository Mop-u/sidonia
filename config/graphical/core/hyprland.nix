{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
    theme = cfg.style.catppuccin;
in
{
    options.sidonia.programs.hyprland = with lib; {
        enable = mkOption {
            type = types.bool;
            default = cfg.graphics.enable;
        };
    };
    config = lib.mkIf (cfg.programs.hyprland.enable) {

        nixpkgs.overlays = lib.optional cfg.graphics.legacyGpu (
            final: prev: {
                # hyprland's legacy renderer is broken in 49.0 and support is dropped in future versions.
                hyprland =
                    (import (pkgs.fetchFromGitHub {
                        owner = "NixOS";
                        repo = "nixpkgs";
                        rev = "b1bebd0fe266bbd1820019612ead889e96a8fa2d";
                        hash = "sha256-MmJvj6mlWzeRwKGLcwmZpKaOPZ5nJb/6al5CXqJsgjo=";
                    }) { inherit (final) system; }).hyprland.override
                        { legacyRenderer = true; };
            }
        );

        catppuccin.sddm = {
            enable = true;
            assertQt6Sddm = true;
            inherit (theme) flavor;
            background = "";
            font = cfg.text.comicCode.name;
            fontSize = "9";
            loginBackground = false;
        };

        services.displayManager = {
            sddm.enable = true;
            sddm.wayland.enable = true;
            sddm.package = pkgs.kdePackages.sddm;
            autoLogin.enable = false;
            autoLogin.user = cfg.userName;
            defaultSession = "hyprland-uwsm";
        };

        programs.hyprland = {
            enable = true;
            withUWSM = true;
        };

        home-manager.users.${cfg.userName} =
            let
                inherit (cfg.desktop) monitors;
            in
            {
                home.packages = [
                    pkgs.hypridle
                    pkgs.hyprcursor
                    pkgs.nwg-look
                    pkgs.hyprshot
                ];
                home.file.xdphCfg = {
                    enable = true;
                    target = "/home/${cfg.userName}/.config/hypr/xdph.conf";
                    text = ''
                        screencopy {
                            max_fps = 60
                            allow_token_by_default = true
                        }
                    '';
                };

                catppuccin.hyprland.enable = false;
                wayland.windowManager.hyprland = {
                    enable = true;
                    systemd.enable = false;
                    systemd.enableXdgAutostart = false;
                    xwayland.enable = true;
                    settings =
                        let
                            shadow_opacity = "55";
                            color = theme.color // {
                                shadow.hex = "000000";
                            };
                            rgb = lib.mapAttrs (n: v: "rgb(${v.hex})") color;
                            rgba = lib.mapAttrs (n: v: (alpha: "rgba(${v.hex}${alpha})")) color;
                        in
                        {
                            monitor = builtins.concatMap (mon: [ mon.enable ]) monitors;

                            xwayland = {
                                force_zero_scaling = true;
                            };

                            env = [
                                # XDG specific #
                                "XDG_SESSION_TYPE,wayland"
                                "XDG_SESSION_DESKTOP,Hyprland"

                                # Theming specific #
                                "WLR_EGL_NO_MODIFIERS,0" # May help with multiple monitors
                                "HYPRCURSOR_SIZE,${builtins.toString cfg.style.cursorSize}"
                                "XCURSOR_SIZE,${builtins.toString cfg.style.cursorSize}"

                                # Toolkit backend vars #
                                "GSK_RENDERER,gl" # Temporary fix for Gdk-Message: Error 71 (Protocol error) dispatching to Wayland display
                                "GDK_BACKEND,wayland,x11,*"
                                "SDL_VIDEODRIVER,wayland,x11,windows"
                                "CLUTTER_BACKEND,wayland"
                                "WLR_RENDERER_ALLOW_SOFTWARE,1" # software rendering backend

                                # QT specific #
                                "QT_AUTO_SCREEN_SCALE_FACTOR,1"
                                "QT_ENABLE_HIGHDPI_SCALING,1"
                                "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
                                "QT_QPA_PLATFORM,wayland;xcb"

                                # App specific #
                                "MOZ_ENABLE_WAYLAND,1"
                                "MOZ_DISABLE_RDD_SANDBOX,1"
                                "MOZ_DBUS_REMOTE,1"

                                # Gaming specific #
                                "__GL_MaxFramesAllowed,1" # Fix frame timings & input lag
                                "PROTON_ENABLE_WAYLAND,1"
                                "PROTON_USE_NTSYNC,1"

                                # Misc #
                                "NIXOS_OZONE_WL,1"
                                #"GDK_SCALE,1"
                                #"GDK_DPI_SCALE,1"
                            ];
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
                                rounding = cfg.window.rounding;
                                active_opacity = 1.0;
                                inactive_opacity = 1.0;
                                shadow = {
                                    enabled = !cfg.graphics.legacyGpu;
                                    range = 12;
                                    render_power = 3;
                                    color = rgba.shadow shadow_opacity; # shadow's color. Alpha dictates shadow's opacity.
                                };
                                blur = {
                                    enabled = !cfg.graphics.legacyGpu;
                                    size = 3;
                                    passes = 1;
                                    vibrancy = 0.1696;
                                };
                            };

                            general = {
                                gaps_in = 5;
                                gaps_out = 20;
                                border_size = cfg.window.borderSize;
                                resize_on_border = false;
                                allow_tearing = true;
                                layout = "dwindle";
                            };

                            dwindle = {
                                pseudotile = true;
                                smart_split = true;
                            };

                            cursor = {
                                no_hardware_cursors = true;
                                no_break_fs_vrr = false;
                                enable_hyprcursor = true;
                            };

                            render = {
                                direct_scanout = 2; # Try turning this off if fullscreen windows/games crash instantly
                            };

                            misc = {
                                force_default_wallpaper = 0;
                                disable_hyprland_logo = true;
                                vrr = 1;
                                mouse_move_enables_dpms = true;
                                key_press_enables_dpms = true;
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
                            windowrulev2 = [
                                "suppressevent maximize, class:.*"
                                "bordercolor ${rgb.overlay2},xwayland:1,focus:0"
                                "bordercolor ${rgb.yellow},  xwayland:1,focus:1"

                                "float, class:(com.saivert.pwvucontrol), title:(Pipewire Volume Control)"

                                "float, class:(gtkwave),title:(gtkwave)"

                                "float, class:(nemo)"

                                "float,                       class:.*, title:(Open File)"
                                "size ${cfg.window.float.wh}, class:.*, title:(Open File)"

                                "float,                       class:.*, title:(Save File)"
                                "size ${cfg.window.float.wh}, class:.*, title:(Save File)"

                                "float,                       class:.*, title:(Select Folder)"
                                "size ${cfg.window.float.wh}, class:.*, title:(Select Folder)"

                                ## xwaylandvideobridge specific ##
                                #"opacity 0.0 override,class:^(xwaylandvideobridge)$"
                                #"noanim,class:^(xwaylandvideobridge)$"
                                #"noinitialfocus,class:^(xwaylandvideobridge)$"
                                #"maxsize 1 1,class:^(xwaylandvideobridge)$"
                                #"noblur,class:^(xwaylandvideobridge)$"
                            ];
                            gestures = {
                                workspace_swipe = true;
                            };
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
                            bindl =
                                [
                                    ", XF86AudioNext,  exec, playerctl next"
                                    ", XF86AudioPause, exec, playerctl play-pause"
                                    ", XF86AudioPlay,  exec, playerctl play-pause"
                                    ", XF86AudioPrev,  exec, playerctl previous"
                                ]
                                ++ (lib.optional cfg.isLaptop ", switch:on:Lid Switch, exec, hyprctl keyword monitor \"${(builtins.head monitors).disable}\"")
                                ++ (lib.optional cfg.isLaptop ", switch:off:Lid Switch, exec, hyprctl keyword monitor \"${(builtins.head monitors).enable}\"");
                            binde = [
                                "SUPERALT,   H,         resizeactive, -10    0" # resize left
                                "SUPERALT,   J,         resizeactive,   0   10" # resize down
                                "SUPERALT,   K,         resizeactive,   0  -10" # resize up
                                "SUPERALT,   L,         resizeactive,  10    0" # resize right
                            ];
                            bind =
                                (builtins.map (x: "${lib.concatStrings x.mod}, ${x.key}, exec, ${x.exec}") cfg.desktop.keybinds)
                                ++ [
                                    "SUPERSHIFT, C,         killactive,"
                                    "SUPERSHIFT, Q,         exec, uwsm stop"
                                    "SUPER,      V,         togglefloating,"
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
            };
    };
}
