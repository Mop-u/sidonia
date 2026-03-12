{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
in
lib.mkIf (cfg.desktop.enable && (cfg.desktop.compositor == "niri")) {
    programs.niri = {
        enable = true;
        inherit (osConfig.programs.niri) package;
        settings = {
            # see: https://github.com/linuxmobile/kaku/blob/niri/home/software/wayland/niri/settings.nix
            # see: https://github.com/sodiboo/niri-flake/blob/main/docs.md
            # see: https://github.com/niri-wm/niri/blob/main/resources/default-config.kdl
            environment = cfg.desktop.environment.niri;
            xwayland-satellite.enable = true;
        };
    };
}
