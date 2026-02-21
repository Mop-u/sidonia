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
    (cfg.desktop.enable && (cfg.desktop.compositor == "hyprland") && (cfg.desktop.shell == "noctalia"))
    {
        # https://docs.noctalia.dev/getting-started/compositor-settings/hyprland/
        wayland.windowManager.hyprland.settings = {
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
    }
