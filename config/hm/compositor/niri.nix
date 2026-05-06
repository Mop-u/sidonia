{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
    inherit (config.wayland.desktopManager.sidonia) window;
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

            xwayland-satellite = {
                enable = lib.mkDefault true;
                path = lib.mkDefault (lib.getExe pkgs.xwayland-satellite-unstable);
            };
            prefer-no-csd = lib.mkDefault true;
            blur.enable = lib.mkDefault (!cfg.graphics.legacyGpu);
            window-rules = [
                {
                    open-fullscreen = false;
                    shadow.enable = false;
                    draw-border-with-background = false;
                    opacity = 1.;
                    background-effect.blur = !cfg.graphics.legacyGpu;
                    popups.background-effect.xray = cfg.graphics.legacyGpu;
                    geometry-corner-radius =
                        let
                            radius = window.decoration.rounding + .0;
                        in
                        {
                            bottom-left = radius;
                            bottom-right = radius;
                            top-left = radius;
                            top-right = radius;
                        };
                }
                (lib.mkIf (!cfg.graphics.legacyGpu) {
                    matches = [ { is-focused = false; } ];
                    opacity = window.decoration.opacity.dec;
                })
                (lib.mkIf (!cfg.graphics.legacyGpu) {
                    matches = [ { is-floating = true; } ];
                    background-effect.xray = false;
                })
            ];
            layer-rules = [
                {
                    shadow.enable = false;
                }
            ];
            layout = {
                always-center-single-column = lib.mkDefault true;
                shadow.enable = lib.mkDefault false;
                focus-ring = {
                    enable = lib.mkDefault true;
                    width = lib.mkDefault window.decoration.borderWidth;
                };
                border = {
                    enable = lib.mkDefault false;
                    width = lib.mkDefault window.decoration.borderWidth;
                };
                default-column-width.proportion = lib.mkDefault 0.5;
                preset-column-widths = [
                    { proportion = 1. / 3.; }
                    { proportion = 1. / 2.; }
                    { proportion = 2. / 3.; }
                    { proportion = 1.; }
                ];
            };
            overview.workspace-shadow.enable = lib.mkDefault (!cfg.graphics.legacyGpu);
            hotkey-overlay.skip-at-startup = lib.mkDefault true;
            gestures.hot-corners.enable = lib.mkDefault false;
        };
    };
}
