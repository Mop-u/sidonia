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
lib.mkIf (cfg.desktop.enable && (cfg.desktop.compositor == "niri")) {
    programs.niri.settings.binds = lib.mkMerge (
        [
            {
                "Super+Shift+C" = {
                    hotkey-overlay.title = "Close Active Window";
                    action.close-window = [ ];
                };
                "Super+Shift+Q" = {
                    hotkey-overlay.title = "Exit Niri Session";
                    action.quit = [ ];
                };
                "Super+V" = {
                    hotkey-overlay.title = "Toggle Window Floating";
                    action.toggle-window-floating = [ ];
                };
                "Super+Shift+V" = {
                    hotkey-overlay.title = "Switch Focus Between Floating And Tiling";
                    action.switch-focus-between-floating-and-tiling = [ ];
                };
                "Print" = {
                    hotkey-overlay.title = "Screenshot Screen";
                    action.screenshot-screen = [ ];
                };
                "Super+Print" = {
                    hotkey-overlay.title = "Screenshot Window";
                    action.screenshot-window = [ ];
                };
                "Super+Shift+Print" = {
                    hotkey-overlay.title = "Interactive Screenshot";
                    action.screenshot = [ ];
                };
            }
        ]
        ++ (builtins.concatLists (
            let
                count = 10;
            in
            builtins.genList (
                x:
                let
                    index = x + 1;
                    key = builtins.toString (lib.mod index count);
                    name = builtins.toString index;
                in
                {
                    "Super+${key}" = {
                        hotkey-overlay.title = "Focus Workspace ${name}";
                        action.focus-workspace = index;
                    };
                    "Super+Shift+${key}" = {
                        hotkey-overlay.title = "Move Window To Workspace ${name}";
                        action.move-window-to-workspace = index;
                    };
                }
            ) count
        ))
    );
}
