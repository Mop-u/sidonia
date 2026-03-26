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
        { wayland.desktopManager.sidonia.window.decoration.rounding = 20; }
        (lib.mkIf (cfg.desktop.compositor == "hyprland") {
            # https://docs.noctalia.dev/getting-started/compositor-settings/hyprland/
            wayland.windowManager.hyprland.settings = {
                exec-once = [ "noctalia-shell" ];
                execr = [ "pkill quickshell; noctalia-shell" ];
                general = {
                    gaps_in = lib.mkDefault 5;
                    gaps_out = lib.mkDefault 10;
                };
                decoration = {
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
                spawn-at-startup = [ { command = [ "noctalia-shell" ]; } ];
                window-rules = [ { clip-to-geometry = true; } ];

                debug.honor-xdg-activation-with-invalid-serial = [ ];

                # for blurred overview wallpaper
                layer-rules = [
                    {
                        matches = [ { namespace = "^noctalia-overview"; } ];
                        place-within-backdrop = true;
                    }
                ];
            };
            #home.activation = {
            #    restartNoctalia = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            #        run ${pkgs.procps}/bin/pkill quickshell
            #        run ${config.programs.niri.package}/bin/niri msg action spawn -- noctalia-shell
            #    '';
            #};
        })
    ]
)
