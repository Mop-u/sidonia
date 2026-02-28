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
lib.mkIf (cfg.desktop.enable && cfg.desktop.shell == "noctalia") (
    lib.mkMerge [
        (lib.mkIf (cfg.desktop.compositor == "hyprland") {
            # https://docs.noctalia.dev/getting-started/compositor-settings/hyprland/
            wayland.windowManager.hyprland.settings = {
                exec-once = [ "noctalia-shell" ];
                general = {
                    gaps_in = 5;
                    gaps_out = 10;
                };
                decoration = {
                    rounding = 20;
                    rounding_power = 2;
                    shadow = {
                        enabled = true;
                        range = 4;
                        render_power = 3;
                        color = "rgba(1a1a1aee)";
                    };
                    blur = {
                        enabled = true;
                        size = 3;
                        passes = 2;
                        vibrancy = 0.1696;
                    };
                };
                layerrule = [
                    {
                        name = "noctalia";
                        "match:namespace" = "noctalia-background-.*$";
                        ignore_alpha = 0.5;
                        blur = true;
                        blur_popups = true;
                    }
                ];
            };
        })
        (lib.mkIf (cfg.desktop.compositor == "niri") {
            # https://docs.noctalia.dev/getting-started/compositor-settings/niri/
            programs.niri.settings = {
                spawn-at-startup = [ { command = [ "noctalia-shell" ]; } ];
                window-rules = [
                    {
                        geometry-corner-radius = 20;
                        clip-to-geometry = true;
                    }
                ];
                debug = {
                    honor-xdg-activation-with-invalid-serial = [ ];
                };

                # for blurred overview wallpaper
                layer-rules = [
                    {
                        matches = [ { namespace = "^noctalia-overview"; } ];
                        place-within-backdrop = true;
                    }
                ];
            };
        })
    ]
)
