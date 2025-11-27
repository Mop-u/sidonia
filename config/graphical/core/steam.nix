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
}
