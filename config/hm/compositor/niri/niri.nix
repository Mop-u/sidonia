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
    home.packages = [ pkgs.xwayland-satellite-unstable ];
    programs.niri = {
        enable = true;
        inherit (osConfig.programs.niri) package;
        settings = {
            # see: https://github.com/linuxmobile/kaku/blob/niri/home/software/wayland/niri/settings.nix
            # see: https://github.com/sodiboo/niri-flake/blob/main/docs.md
            # see: https://github.com/niri-wm/niri/blob/main/resources/default-config.kdl
            environment = cfg.desktop.environment.niri;
            xwayland-satellite = {
                enable = true;
                path = lib.getExe pkgs.xwayland-satellite-unstable;
            };
            prefer-no-csd = true;
            window-rules = [
                {
                    open-fullscreen = false;
                    draw-border-with-background = false;
                    opacity = 1.;
                }
                {
                    matches = [ { is-focused = false; } ];
                    opacity = 0.95;
                }
            ];
            layout = {
                always-center-single-column = true;
                focus-ring = {
                    enable = true;
                    width = cfg.desktop.window.decoration.borderWidth;
                };
                border = {
                    enable = false;
                    width = cfg.desktop.window.decoration.borderWidth;
                };
                preset-column-widths = [
                    { proportion = 1. / 3.; }
                    { proportion = 1. / 2.; }
                    { proportion = 2. / 3.; }
                    { proportion = 1.; }
                ];
            };
            hotkey-overlay.skip-at-startup = true;
            gestures.hot-corners.enable = false;
        };
    };
}
