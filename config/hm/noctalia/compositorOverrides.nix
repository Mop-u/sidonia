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
lib.mkIf (cfg.desktop.enable && cfg.desktop.compositor == "niri") (
    lib.mkMerge [
        {
            wayland.desktopManager.sidonia.window.decoration.rounding = 20;
            programs.niri.settings = {
                window-rules = [ { clip-to-geometry = true; } ];
                debug.honor-xdg-activation-with-invalid-serial = [ ];
            };
        }
        (lib.mkIf (cfg.desktop.shell == "noctalia-legacy") {
            # https://docs.noctalia.dev/getting-started/compositor-settings/niri/
            programs.niri.settings = {
                spawn-at-startup = [ { command = [ "noctalia-shell" ]; } ];
                layer-rules = [
                    {
                        matches = [ { namespace = "^noctalia-overview"; } ];
                        place-within-backdrop = true;
                    }
                    (lib.mkIf (!cfg.graphics.legacyGpu) {
                        matches = [ { namespace = "^noctalia-(background|launcher-overlay|dock)-.*$"; } ];
                        background-effect.xray = false;
                    })
                ];
            };
        })
        (lib.mkIf (cfg.desktop.shell == "noctalia") {
            programs.niri.settings = {
                spawn-at-startup = [ { command = [ "noctalia" ]; } ];
                window-rules = [
                    {
                        matches = [ { app-id = "dev.noctalia.Noctalia.Settings"; } ];
                        open-floating = true;
                        default-column-width.fixed = 1080;
                        default-window-height.fixed = 920;
                    }
                ];
                layer-rules = [
                    {
                        matches = [ { namespace = "^noctalia-backdrop"; } ];
                        place-within-backdrop = true;
                    }
                    (lib.mkIf (!cfg.graphics.legacyGpu) {
                        matches = [ { namespace = "^noctalia-(bar-main|notification|dock|panel)$"; } ];
                        background-effect.xray = false;
                    })
                ];
            };
        })
    ]
)
