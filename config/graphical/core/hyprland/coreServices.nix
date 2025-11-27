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
lib.mkIf (cfg.programs.hyprland.enable) {

    security = {
        pam.services = {
            sddm.enableGnomeKeyring = true;
            login.enableGnomeKeyring = true;
        };
        polkit.enable = true;
    };

    xdg = {
        terminal-exec = {
            enable = true;
            settings.default = [
                "foot.desktop"
            ];
        };
        autostart.enable = true;
        portal = {
            extraPortals = [
                pkgs.xdg-desktop-portal-gnome
            ];
        };
    };

    environment.sessionVariables = {
        XDG_CONFIG_DIRS = [ "$HOME/.config" ]; # this is missing by default, needed for ~/.config/autostart
    };

    services = {
        logind.settings.Login = {
            HandleLidSwitch = "suspend-then-hibernate";
            HandleLidSwitchExternalPower = "ignore";
            HandleLidSwitchDocked = "ignore";
        };

        gvfs.enable = true; # Mount, trash, and other functionalities

        tumbler.enable = true; # Thumbnail support for images

        blueman.enable = true;

        playerctld.enable = true;
    };

    programs = {
        seahorse.enable = true;
        xfconf.enable = true;
        nm-applet.enable = true; # systemd graphical-session.target
    };

    home-manager.users.${cfg.userName} = {
        catppuccin.cursors = {
            enable = true;
            accent = theme.accent;
            flavor = theme.flavor;
        };

        home.file.nmAppletDropin = {
            enable = true;
            target = "/home/${cfg.userName}/.config/systemd/user/nm-applet.service.d/dropin.conf";
            text = ''
                [Service]
                Restart=on-failure
                RestartSec=3
            '';
        };

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
            blueman-applet.enable = true; # systemd graphical-session.target
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
    };
}
