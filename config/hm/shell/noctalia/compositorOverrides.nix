{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
    restartNoctalia = "pkill quickshell; noctalia-shell";
in
lib.mkIf (cfg.desktop.enable && cfg.desktop.shell == "noctalia") (
    lib.mkMerge [
        (lib.mkIf (cfg.desktop.compositor == "hyprland") {
            # https://docs.noctalia.dev/getting-started/compositor-settings/hyprland/
            wayland.windowManager.hyprland.settings = {
                exec-once = [ "noctalia-shell" ];
                execr = [ restartNoctalia ];
                general = {
                    gaps_in = lib.mkDefault 5;
                    gaps_out = lib.mkDefault 10;
                };
                decoration = {
                    rounding = lib.mkDefault 20;
                    rounding_power = lib.mkDefault 2;
                    shadow = {
                        enabled = lib.mkDefault true;
                        range = lib.mkDefault 4;
                        render_power = lib.mkDefault 3;
                        color = lib.mkDefault "rgba(1a1a1aee)";
                    };
                    blur = {
                        enabled = lib.mkDefault true;
                        size = lib.mkDefault 3;
                        passes = lib.mkDefault 2;
                        vibrancy = lib.mkDefault 0.1696;
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
                spawn-at-startup = [ { command = [ "${pkgs.writeScript "Restart Noctalia" restartNoctalia}" ]; } ];
                window-rules = [
                    {
                        geometry-corner-radius =
                            let
                                radius = 20.000;
                            in
                            builtins.mapAttrs (n: v: lib.mkDefault v) {
                                bottom-left = radius;
                                bottom-right = radius;
                                top-left = radius;
                                top-right = radius;
                            };
                        clip-to-geometry = lib.mkDefault true;
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
