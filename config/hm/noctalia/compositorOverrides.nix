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
lib.mkIf
    (cfg.desktop.enable && (cfg.desktop.compositor == "niri") && (cfg.desktop.shell == "noctalia"))
    {
        wayland.desktopManager.sidonia.window.decoration.rounding = 20;
        programs.niri.settings = {
            window-rules = [
                { clip-to-geometry = true; }
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
            debug.honor-xdg-activation-with-invalid-serial = [ ];
        };
    }
