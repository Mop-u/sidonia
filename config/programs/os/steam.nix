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
    programs = {
        steam = {
            enable = lib.mkDefault true;
            package = pkgs.steam.override {
                #extraProfile = "unset TZ";
                extraEnv = cfg.desktop.environment.steam;
            };
            protontricks.enable = lib.mkDefault true;
            localNetworkGameTransfers.openFirewall = lib.mkDefault true;
            extest.enable = lib.mkDefault true;

            # https://github.com/NixOS/nixpkgs/issues/162562#issuecomment-1523177264
            extraPackages = with pkgs; [
                xorg.libXcursor
                xorg.libXi
                xorg.libXinerama
                xorg.libXScrnSaver
                libpng
                libpulseaudio
                libvorbis
                stdenv.cc.cc.lib
                libkrb5
                keyutils
                gamescope
                scopebuddy
            ];
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
    home-manager.users.${cfg.userName}.wayland.windowManager.hyprland.settings.windowrule = [
        "match:initial_class ^steam_app_\\d+$, content game, tag +game"
        "match:xdg_tag proton-game, content game, tag +game"
        "match:tag game, fullscreen on, workspace special:magic, idle_inhibit always, render_unfocused on, immediate on, no_vrr on"
    ];
}
