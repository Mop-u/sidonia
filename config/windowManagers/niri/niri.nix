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
    # see: https://github.com/linuxmobile/kaku/blob/niri/home/software/wayland/niri/settings.nix
    # see: https://github.com/sodiboo/niri-flake/blob/main/docs.md
    config = lib.mkIf (cfg.graphics.enable) {
        home-manager.users.${cfg.userName}.programs.niri = {
            enable = false;
            package = pkgs.niri-stable;
            settings = {
                environment = {
                    XDG_SESSION_TYPE = "wayland";
                    WLR_EGL_NO_MODIFIERS = "0";
                    XCURSOR_SIZE = builtins.toString cfg.style.cursorSize;
                    GDK_BACKEND = "wayland,x11,*";
                    SDL_VIDEODRIVER = "wayland,x11,windows";
                    CLUTTER_BACKEND = "wayland";

                    WLR_RENDERER_ALLOW_SOFTWARE = "1";

                    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
                    QT_ENABLE_HIGHDPI_SCALING = "1";
                    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
                    QT_QPA_PLATFORM = "wayland;xcb";

                    MOZ_ENABLE_WAYLAND = "1";
                    MOZ_DISABLE_RDD_SANDBOX = "1";
                    MOZ_DBUS_REMOTE = "1";

                    __GL_MaxFramesAllowed = "1";
                    PROTON_ENABLE_WAYLAND = "1";
                    PROTON_USE_NTSYNC = "1";

                    NIXOS_OZONE_WL = "1";
                };
            };
        };
    };
}
