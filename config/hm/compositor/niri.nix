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
    wayland.windowManager.niri = {
        enable = true;
        package = pkgs.niri-unstable;
        settings = {
            # see: https://codeberg.org/BANanaD3V/niri-nix/src/branch/main/home-options.md
            cursor = {
                hide-when-typing = [];
                hide-after-inactive-ms = lib.mkDefault 5000;
            };

            input = {
                warp-mouse-to-focus._props.mode = lib.mkDefault "center-xy";
            };

            xwayland-satellite.path = lib.mkDefault (lib.getExe pkgs.xwayland-satellite-unstable);

            prefer-no-csd = [];
            blur = lib.mkIf cfg.graphics.legacyGpu { off = []; };
            window-rule = [
                {
                    open-fullscreen = false;
                    shadow.off = [];
                    draw-border-with-background = false;
                    opacity = 1.;
                    background-effect.blur = !cfg.graphics.legacyGpu;
                    popups.background-effect.xray = cfg.graphics.legacyGpu;
                    geometry-corner-radius = window.decoration.rounding;
                }
                {
                    match._props.is-focused = false;
                    opacity = window.decoration.opacity.dec;
                }
                (lib.mkIf (!cfg.graphics.legacyGpu) {
                    match._props.is-floating = true;
                    background-effect.xray = false;
                })
            ];
            layer-rule = [{ shadow.off = []; }];
            layout = {
                always-center-single-column = [];
                shadow.off = [];
                focus-ring = {
                    on = [];
                    width = lib.mkDefault window.decoration.borderWidth;
                };
                border = {
                    off = [];
                    width = lib.mkDefault window.decoration.borderWidth;
                };
                default-column-width.proportion = lib.mkDefault 0.5;
                preset-column-widths._children = [
                    { proportion = 1. / 3.; }
                    { proportion = 1. / 2.; }
                    { proportion = 2. / 3.; }
                    { proportion = 1.; }
                ];
            };
            overview.workspace-shadow.off = [];
            hotkey-overlay.skip-at-startup = [];
            gestures.hot-corners.off = [];
        };
    };
}
