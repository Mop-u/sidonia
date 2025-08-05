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

    # enable virtual camera for OBS
    boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    boot.extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';

    programs = {
        steam = {
            enable = true;
            protontricks.enable = true;
            extest.enable = true;
            gamescopeSession =
                {
                    enable = true;
                }
                // (lib.mkIf config.hardware.nvidia.prime.offload.enable {
                    env = {
                        # for Prime render offload on Nvidia laptops.
                        __NV_PRIME_RENDER_OFFLOAD = "1";
                        __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA_G0";
                        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
                        __VK_LAYER_NV_optimus = "NVIDIA_only";
                    };
                });
        };
        anime-games-launcher.enable = !cfg.graphics.legacyGpu; # multi launcher
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
    };
}
