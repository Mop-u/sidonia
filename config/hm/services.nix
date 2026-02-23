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
in
lib.mkIf (cfg.desktop.enable) {

    services = {
        gnome-keyring.enable = true;
    };

    home.packages = with pkgs; [
        # Hyprland / core apps
        qimgv
        mpv # video player
        dconf-editor # view gsettings stuff
        gsettings-desktop-schemas
        ungoogled-chromium
    ];

    xdg = {
        systemDirs.config = [ "${config.home.homeDirectory}/.config" ]; # this is missing by default, needed for ~/.config/autostart
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
