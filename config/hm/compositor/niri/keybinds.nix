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
                    repeat = false;
                    action.close-window = [ ];
                };
                "Super+MouseMiddle" = {
                    hotkey-overlay.title = "Close Active Window";
                    repeat = false;
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
                "Super+F" = {
                    hotkey-overlay.title = "Maximize Column";
                    action.maximize-column = [ ];
                };
                "Super+Ctrl+F" = {
                    hotkey-overlay.title = "Expand Column to Available Width";
                    action.expand-column-to-available-width = [ ];
                };
                "Super+Shift+F" = {
                    hotkey-overlay.title = "Fullscreen";
                    action.fullscreen-window = [ ];
                };
                "Super+Shift+V" = {
                    hotkey-overlay.title = "Switch Focus Between Floating And Tiling";
                    action.switch-focus-between-floating-and-tiling = [ ];
                };

                "Super+Space" = {
                    hotkey-overlay.title = "Toggle Overview";
                    repeat = false;
                    action.toggle-overview = [ ];
                };

                "Super+H" = {
                    hotkey-overlay.title = "Move Focus Left";
                    action.focus-column-left = [ ];
                };
                "Super+L" = {
                    hotkey-overlay.title = "Move Focus Right";
                    action.focus-column-right = [ ];
                };
                "Super+Shift+H" = {
                    hotkey-overlay.title = "Move Column Left";
                    action.move-column-left = [ ];
                };
                "Super+Shift+L" = {
                    hotkey-overlay.title = "Move Column Right";
                    action.move-column-right = [ ];
                };
                "Super+Alt+H" = {
                    hotkey-overlay.title = "Cycle Column Width Up";
                    action.switch-preset-column-width = [ ];
                };
                "Super+Alt+L" = {
                    hotkey-overlay.title = "Cycle Column Width Down";
                    action.switch-preset-column-width-back = [ ];
                };

                "Super+J" = {
                    hotkey-overlay.title = "Move Focus Down";
                    action.focus-window-down = [ ];
                };
                "Super+K" = {
                    hotkey-overlay.title = "Move Focus Up";
                    action.focus-window-up = [ ];
                };
                "Super+Shift+J" = {
                    hotkey-overlay.title = "Move Window Down";
                    action.move-window-down = [ ];
                };
                "Super+Shift+K" = {
                    hotkey-overlay.title = "Move Window Up";
                    action.move-window-up = [ ];
                };

                "Super+WheelScrollDown" = {
                    hotkey-overlay.title = "Scroll to Next Workspace";
                    cooldown-ms = 150;
                    action.focus-workspace-down = [ ];
                };
                "Super+WheelScrollUp" = {
                    hotkey-overlay.title = "Scroll to Prev Workspace";
                    cooldown-ms = 150;
                    action.focus-workspace-up = [ ];
                };
                "Super+Shift+WheelScrollDown" = {
                    hotkey-overlay.title = "Scroll Layout Right";
                    cooldown-ms = 150;
                    action.focus-column-right = [ ];
                };
                "Super+Shift+WheelScrollUp" = {
                    hotkey-overlay.title = "Scroll Layout Left";
                    cooldown-ms = 150;
                    action.focus-column-left = [ ];
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
        ++ (
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
        )
    );
}
