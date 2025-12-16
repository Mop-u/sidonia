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
            enable = lib.mkDefault true;
            protontricks.enable = lib.mkDefault true;
            localNetworkGameTransfers.openFirewall = lib.mkDefault true;
            extest.enable = lib.mkDefault true;
            extraCompatPackages = [
                pkgs.proton-ge-bin
                pkgs.steam-play-none
            ];
            gamescopeSession.env = lib.mkIf config.hardware.nvidia.prime.offload.enable {
                # for Prime render offload on Nvidia laptops.
                __NV_PRIME_RENDER_OFFLOAD = "1";
                __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA_G0";
                __GLX_VENDOR_LIBRARY_NAME = "nvidia";
                __VK_LAYER_NV_optimus = "NVIDIA_only";
            };
        };
    };
}
