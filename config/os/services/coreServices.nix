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

    programs.dconf.enable = true;

    # https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.portal.enable
    environment.pathsToLink = [
        "/share/xdg-desktop-portal"
        "/share/applications"
    ];

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

    # https://gitlab.com/mission-center-devs/mission-center/-/wikis/Home/CPU
    services.udev.extraRules = ''
        SUBSYSTEM=="powercap", KERNEL=="intel-rapl*", \
            RUN+="${pkgs.coreutils}/bin/chgrp -R wheel /sys/%p/'", \
            RUN+="${pkgs.coreutils}/bin/chmod -R g+r /sys/%p/"
    '';

    security.wrappers.nethogs = {
        enable = true;
        owner = "root";
        group = "root";
        source = lib.getExe pkgs.nethogs;
        capabilities = lib.concatStringsSep "," [
            "cap_net_admin"
            "cap_net_raw"
            "cap_dac_read_search"
            "cap_sys_ptrace+pe"
        ];
    };

}
