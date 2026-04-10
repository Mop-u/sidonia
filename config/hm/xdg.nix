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
lib.mkIf (cfg.desktop.enable) {
    xdg = {
        autostart.enable = true;
        portal = {
            enable = true;
            xdgOpenUsePortal = true;
            extraPortals = [
                pkgs.xdg-desktop-portal
                pkgs.xdg-desktop-portal-gtk
                pkgs.xdg-desktop-portal-gnome
            ];
            config = {
                common = {
                    default = [ "gtk" ];
                };
                hyprland = {
                    default = [
                        "hyprland"
                        "gtk"
                    ];
                    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
                    "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
                };
                niri = {
                    default = [
                        "gtk"
                        "gnome"
                    ];
                    "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
                    "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
                };
            };
        };

        mimeApps =
            let
                browser = "floorp.desktop";
                imageViewer = "qimgv.desktop";
            in
            {
                enable = true;
                defaultApplications = {
                    "text/html" = [ browser ];
                    "x-scheme-handler/http" = [ browser ];
                    "x-scheme-handler/https" = [ browser ];
                    "x-scheme-handler/about" = [ browser ];
                    "x-scheme-handler/unknown" = [ browser ];
                    "image/jpg" = [ imageViewer ];
                    "image/jpeg" = [ imageViewer ];
                    "image/png" = [ imageViewer ];
                    "image/bmp" = [ imageViewer ];
                    "image/gif" = [ imageViewer ];
                    "image/webp" = [ imageViewer ];
                    "image/x-sony-arw" = [ imageViewer ];
                };
                associations.added = {
                    "image/jpg" = imageViewer;
                };
            };
    };
}
