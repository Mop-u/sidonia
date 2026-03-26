{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
in
{
    options.programs.steam.extraEnv = lib.mkOption {
        description = "Extra environment variables for steam.";
        type = with lib.types; attrsOf (nullOr (coercedTo int (builtins.toString) str));
        default = { };
        apply = x: lib.filterAttrs (n: v: v != null) x;
    };
    config = lib.mkIf (cfg.desktop.enable) {
        programs = {
            steam = {
                enable = lib.mkDefault true;
                package = pkgs.steam.override {
                    #extraProfile = "unset TZ";
                    inherit (config.programs.steam) extraEnv;
                };
                protontricks.enable = lib.mkDefault true;
                localNetworkGameTransfers.openFirewall = lib.mkDefault true;
                extest.enable = lib.mkDefault true;
                extraCompatPackages = [
                    pkgs.dwproton
                    pkgs.proton-ge-bin
                    pkgs.steam-play-none
                ];
            };
        };
        environment.systemPackages = [ pkgs.gamescope-wsi ]; # for gamescope hdr support

        home-manager.users.${cfg.userName}.wayland.windowManager.hyprland.settings.windowrule = [
            "match:initial_class ^steam_app_\\d+$, content game, tag +game"
            "match:xdg_tag proton-game, content game, tag +game, no_vrr on"
            "match:tag game, fullscreen on, workspace special:magic, idle_inhibit always, render_unfocused on, immediate on"
        ];
    };
}
