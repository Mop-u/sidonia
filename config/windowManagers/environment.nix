{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
    mapListToAttrs =
        f: list:
        builtins.listToAttrs (
            builtins.map (name: {
                inherit name;
                value = (f name);
            }) list
        );
in
{
    options.sidonia.desktop.environment =
        mapListToAttrs
            (
                n:
                lib.mkOption {
                    description = "Environment variables for ${n} context.";
                    type = with lib.types; attrsOf (nullOr (coercedTo int (builtins.toString) str));
                    default = { };
                    apply = x: lib.filterAttrs (n: v: v != null) x;
                }
            )
            [
                "wayland"
                "niri"
                "hyprland"
                "steam"
            ];
    config = {
        sidonia.desktop.environment = {
            wayland = builtins.mapAttrs (n: v: lib.mkDefault v) {
                XDG_SESSION_TYPE = "wayland";
                XCURSOR_SIZE = (builtins.toString cfg.style.cursorSize);
                GDK_BACKEND = "wayland,x11,*";
                SDL_VIDEODRIVER = "wayland";
                SDL_VIDEO_DRIVER = "wayland";
                CLUTTER_BACKEND = "wayland";
                NIXOS_OZONE_WL = 1;
                ELECTRON_ENABLE_WAYLAND = 1;
                ELECTRON_OZONE_PLATFORM_HINT = "wayland";
                QT_AUTO_SCREEN_SCALE_FACTOR = 1;
                QT_ENABLE_HIGHDPI_SCALING = 1;
                QT_QPA_PLATFORM = "wayland;xcb";
                MOZ_ENABLE_WAYLAND = 1;
                MOZ_DISABLE_RDD_SANDBOX = 1;
                MOZ_DBUS_REMOTE = 1;
            };
            hyprland = builtins.mapAttrs (n: v: lib.mkDefault v) (
                cfg.desktop.environment.wayland
                // {
                    XDG_SESSION_DESKTOP = "Hyprland";
                    WLR_EGL_NO_MODIFIERS = 0; # May help with multiple monitors
                    HYPRCURSOR_SIZE = cfg.style.cursorSize;
                    WLR_RENDERER_ALLOW_SOFTWARE = 1;
                    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
                    __GL_MaxFramesAllowed = 1; # Fix frame timings & input lag
                }
            );
            niri = builtins.mapAttrs (n: v: lib.mkDefault v) (
                cfg.desktop.environment.wayland
                // {
                    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
                }
            );
        };
    };
}
