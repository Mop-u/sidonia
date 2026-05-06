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
lib.mkIf (cfg.desktop.enable && cfg.desktop.shell == "noctalia-legacy") (
    lib.mkMerge [
        { wayland.desktopManager.sidonia.window.decoration.rounding = 20; }
        (lib.mkIf (cfg.desktop.compositor == "niri") {
            # https://docs.noctalia.dev/getting-started/compositor-settings/niri/
            programs.niri.settings = {
                spawn-at-startup = [ { command = [ "noctalia-shell" ]; } ];
                window-rules = [ { clip-to-geometry = true; } ];

                debug.honor-xdg-activation-with-invalid-serial = [ ];

                layer-rules = [
                    {
                        matches = [ { namespace = "^noctalia-overview"; } ];
                        place-within-backdrop = true;
                    }
                    {
                        matches = [ { namespace = "^noctalia-(background|launcher-overlay|dock)-.*$"; } ];
                        background-effect.xray = osConfig.sidonia.graphics.legacyGpu;
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
