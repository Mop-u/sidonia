{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
in
lib.mkIf (cfg.graphics.enable) {
    home-manager.users.${cfg.userName} = {
        home.packages = with pkgs; [
            # GUI apps
            pinta # Paint.NET-like image editor
            #plex-desktop # doesn't launch
            heroic
            protonvpn-gui
            slack
            prismlauncher
            #xivlauncher
            plexamp
            surfer
            bambu-studio
            tageditor
            affinity
        ];

        programs = {
            obs-studio = {
                enable = true;
                plugins = with pkgs.obs-studio-plugins; [
                    wlrobs
                ];
            };
        };
        # enable virtual camera for OBS
        #boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
        #boot.extraModprobeConfig = ''
        #    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
        #'';
    };
}
