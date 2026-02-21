{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
in
lib.mkIf (cfg.desktop.enable) {

    security = {
        pam.services = {
            sddm.enableGnomeKeyring = true;
            login.enableGnomeKeyring = true;
        };
        polkit.enable = true;
    };

    xdg = {
        autostart.enable = true;
        portal = {
            extraPortals = [
                pkgs.xdg-desktop-portal
                pkgs.xdg-desktop-portal-gtk
                pkgs.xdg-desktop-portal-gnome
            ];
            config = {
                common = {
                    default = [ "gtk" ];
                    "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
                };
                hyprland = {
                    default = [
                        "hyprland"
                        "gtk"
                    ];
                    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
                    "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
                };
            };
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
    };

    programs = {
        seahorse.enable = true;
        xfconf.enable = true;
    };

}
