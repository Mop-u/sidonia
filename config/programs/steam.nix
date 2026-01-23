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
        };
    };
    environment.systemPackages = [ pkgs.gamescope-wsi ]; # for gamescope hdr support
    sidonia.desktop.environment.steam = lib.mkMerge [
        (lib.mkIf config.hardware.nvidia.prime.offload.enable {
            # for Prime render offload on Nvidia laptops.
            __NV_PRIME_RENDER_OFFLOAD = "1";
            __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA_G0";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
            __VK_LAYER_NV_optimus = "NVIDIA_only";
        })
        (builtins.mapAttrs (n: v: lib.mkDefault v) {
            PROTON_ENABLE_WAYLAND = 1;
            PROTON_USE_NTSYNC = 1;
            PROTON_FSR4_UPGRADE = 1;
            PROTON_DLSS_UPGRADE = 1;
        })
    ];
    nixpkgs.overlays = [
        (final: prev: {
            steam = prev.steam.override {
                extraProfile = builtins.concatStringsSep "\n" (
                    (lib.mapAttrsToList (n: v: "export ${n}=${v}") cfg.desktop.environment.steam) ++ [ "unset TZ" ]
                );
            };
        })
    ];
}
