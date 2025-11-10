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

    programs = {
        steam = {
            enable = true;
            protontricks.enable = true;
            localNetworkGameTransfers.openFirewall = true;
            extest.enable = true;
            extraCompatPackages = [
                pkgs.proton-ge-bin
                pkgs.steam-play-none
            ];
            gamescopeSession = lib.mkMerge [
                {
                    enable = true;
                }
                (lib.mkIf config.hardware.nvidia.prime.offload.enable {
                    env = {
                        # for Prime render offload on Nvidia laptops.
                        __NV_PRIME_RENDER_OFFLOAD = "1";
                        __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA_G0";
                        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
                        __VK_LAYER_NV_optimus = "NVIDIA_only";
                    };
                })
            ];
        };
    };

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
