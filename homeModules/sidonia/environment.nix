{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.wayland.desktopManager.sidonia;
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
    options.wayland.desktopManager.sidonia.environment = lib.mkOption {
        description = "Environment variables initialized by the compositor.";
        type = with lib.types; attrsOf (nullOr (coercedTo int (builtins.toString) str));
        default = { };
        apply = x: lib.filterAttrs (n: v: v != null) x;
    };
    config = lib.mkIf osConfig.sidonia.desktop.enable (
        lib.mkMerge [
            {
                wayland.desktopManager.sidonia.environment = builtins.mapAttrs (n: v: lib.mkDefault v) {
                    XDG_SESSION_TYPE = "wayland";
                    SDL_VIDEODRIVER = "wayland,x11";
                    SDL_VIDEO_DRIVER = "wayland";
                    CLUTTER_BACKEND = "wayland";
                    ELM_DISPLAY = "wl";
                    NIXOS_OZONE_WL = 1;
                    ELECTRON_ENABLE_WAYLAND = 1;
                    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
                    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
                    QT_ENABLE_HIGHDPI_SCALING = 1;
                    QT_QPA_PLATFORM = "wayland;xcb";
                    QT_QPA_PLATFORMTHEME = "gtk3";
                    MOZ_ENABLE_WAYLAND = 1;
                    MOZ_DISABLE_RDD_SANDBOX = 1;
                    MOZ_DBUS_REMOTE = 1;
                };
            }
            (lib.mkIf (osConfig.sidonia.desktop.compositor == "hyprland") {
                wayland.windowManager.hyprland.settings.env = lib.mapAttrsToList (n: v: "${n},${v}") (
                    builtins.mapAttrs (n: v: lib.mkDefault v) (
                        cfg.environment
                        // {
                            XDG_SESSION_DESKTOP = "Hyprland";
                            XDG_CURRENT_DESKTOP = "Hyprland";
                            WLR_RENDERER_ALLOW_SOFTWARE = 1;
                            QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
                            __GL_MaxFramesAllowed = 1; # Fix frame timings & input lag
                        }
                    )
                );
            })
            (lib.mkIf (osConfig.sidonia.desktop.compositor == "niri") {
                programs.niri.settings.environment = builtins.mapAttrs (n: v: lib.mkDefault v) (
                    cfg.environment // { QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; }
                );
            })
        ]
    );
}
