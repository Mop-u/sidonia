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
    catppuccin.cursors = {
        enable = true;
        accent = theme.accent;
        flavor = theme.flavor;
    };

    xdg.configFile."systemd/user/nm-applet.service.d/dropin.conf".text = ''
        [Service]
        Restart=on-failure
        RestartSec=3
    '';

    qt = {
        enable = true;
        style.name = "kvantum";
        platformTheme.name = "kvantum";
    };
    catppuccin.kvantum = {
        enable = true;
        apply = true;
    };

    services = {
        gnome-keyring.enable = true;
    };

    home.packages = with pkgs; [
        # Hyprland / core apps
        pwvucontrol
        qpwgraph
        mate.engrampa # archive manager
        qimgv
        mpv # video player
        dconf-editor # view gsettings stuff
        gsettings-desktop-schemas
        ungoogled-chromium
        ffmpegthumbnailer
        webp-pixbuf-loader
        (nemo-with-extensions.overrideAttrs { extraNativeBuildInputs = [ pkgs.gvfs ]; })
        brightnessctl
    ];

    xdg = {
        mimeApps.enable = true;
        mimeApps.defaultApplications =
            let
                browser = "floorp.desktop";
                imageViewer = "qimgv.desktop";
                fileExplorer = "nemo.desktop";
            in
            {
                "text/html" = browser;
                "x-scheme-handler/http" = browser;
                "x-scheme-handler/https" = browser;
                "x-scheme-handler/about" = browser;
                "x-scheme-handler/unknown" = browser;
                "image/jpg" = imageViewer;
                "image/jpeg" = imageViewer;
                "image/png" = imageViewer;
                "image/bmp" = imageViewer;
                "image/gif" = imageViewer;
                "image/webp" = imageViewer;
                "image/x-sony-arw" = imageViewer;
                "inode/directory" = fileExplorer;
                "application/x-gnome-saved-search" = fileExplorer;
            };
        mimeApps.associations.added = {
            "image/jpg" = "qimgv.desktop";
        };
        desktopEntries = {

        };
    };
}
