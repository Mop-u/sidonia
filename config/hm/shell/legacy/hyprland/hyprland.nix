{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
    theme = cfg.style.catppuccin;
in
lib.mkIf
    (cfg.desktop.enable && (cfg.desktop.compositor == "hyprland") && (cfg.desktop.shell == "legacy"))
    {
        wayland.windowManager.hyprland.settings =
            let
                shadow_opacity = "55";
                color = theme.color // {
                    shadow = "000000";
                };
                rgb = lib.mapAttrs (n: v: "rgb(${v})") color;
                rgba = lib.mapAttrs (n: v: (alpha: "rgba(${v}${alpha})")) color;
            in
            {
                general = {
                    gaps_in = 5;
                    gaps_out = 20;
                };
                decoration = {
                    rounding = cfg.desktop.window.decoration.rounding;
                    shadow = {
                        enabled = true;
                        range = 12;
                        render_power = 3;
                        color = rgba.shadow shadow_opacity; # shadow's color. Alpha dictates shadow's opacity.
                    };
                    blur = {
                        enabled = true;
                        size = 3;
                        passes = 1;
                        vibrancy = 0.1696;
                    };
                };
            };
    }
