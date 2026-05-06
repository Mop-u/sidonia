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
lib.mkIf cfg.desktop.enable {
    wayland.desktopManager.sidonia.keybinds = [
        {
            name = "Close Active Window";
            mod = [
                "Super"
                "Shift"
            ];
            key = "C";
            perCompositor = {
                niri = {
                    repeat = false;
                    action.close-window = [ ];
                };
            };
        }
        {
            name = "Close Active Window";
            mod = "Super";
            key = "MouseMiddle";
            perCompositor = {
                niri = {
                    repeat = false;
                    action.close-window = [ ];
                };
            };
        }
        {
            name = "Exit Session";
            mod = [
                "Super"
                "Shift"
            ];
            key = "Q";
            perCompositor = {
                niri.action.quit = [ ];
            };
        }
        {
            name = "Toggle Window Floating";
            mod = "Super";
            key = "V";
            perCompositor = {
                niri.action.toggle-window-floating = [ ];
            };
        }
        {
            name = "Switch Focus Between Floating and Tiling";
            mod = [
                "Super"
                "Shift"
            ];
            key = "V";
            perCompositor = {
                niri.action.switch-focus-between-floating-and-tiling = [ ];
            };
        }
        {
            name = "Maximize Column";
            mod = "Super";
            key = "F";
            perCompositor = {
                niri.action.maximize-column = [ ];
            };
        }
        {
            name = "Expand Column to Available Width";
            mod = [
                "Super"
                "Ctrl"
            ];
            key = "F";
            perCompositor = {
                niri.action.expand-column-to-available-width = [ ];
            };
        }
        {
            name = "Toggle Fullscreen";
            mod = [
                "Super"
                "Shift"
            ];
            key = "F";
            perCompositor = {
                niri.action.fullscreen-window = [ ];
            };
        }
        {
            name = "Move Focus Left";
            mod = "Super";
            key = "H";
            perCompositor = {
                niri.action.focus-column-left = [ ];
            };
        }
        {
            name = "Move Focus Right";
            mod = "Super";
            key = "L";
            perCompositor = {
                niri.action.focus-column-right = [ ];
            };
        }
        {
            name = "Move Column Left";
            mod = [
                "Super"
                "Shift"
            ];
            key = "H";
            perCompositor = {
                niri.action.move-column-left = [ ];
            };
        }
        {
            name = "Move Column Left";
            mod = "Super";
            key = "MouseForward";
            perCompositor = {
                niri.action.move-column-left = [ ];
            };
        }
        {
            name = "Move Column Right";
            mod = [
                "Super"
                "Shift"
            ];
            key = "L";
            perCompositor = {
                niri.action.move-column-right = [ ];
            };
        }
        {
            name = "Move Column Right";
            mod = "Super";
            key = "MouseBack";
            perCompositor = {
                niri.action.move-column-right = [ ];
            };
        }
        {
            name = "Decrease Column Width";
            mod = [
                "Super"
                "Alt"
            ];
            key = "H";
            perCompositor = {
                niri.action.switch-preset-column-width-back = [ ];
            };
        }
        {
            name = "Decrease Column Width";
            mod = [
                "Super"
                "Alt"
            ];
            key = "WheelScrollDown";
            perCompositor = {
                niri.action.switch-preset-column-width-back = [ ];
            };
        }
        {
            name = "Increase Column Width";
            mod = [
                "Super"
                "Alt"
            ];
            key = "L";
            perCompositor = {
                niri.action.switch-preset-column-width = [ ];
            };
        }
        {
            name = "Increase Column Width";
            mod = [
                "Super"
                "Alt"
            ];
            key = "WheelScrollUp";
            perCompositor = {
                niri.action.switch-preset-column-width = [ ];
            };
        }
        {
            name = "Move Focus Down";
            mod = "Super";
            key = "J";
            perCompositor = {
                niri.action.focus-window-down = [ ];
            };
        }
        {
            name = "Move Focus Up";
            mod = "Super";
            key = "K";
            perCompositor = {
                niri.action.focus-window-up = [ ];
            };
        }
        {
            name = "Move Window Down";
            mod = [
                "Super"
                "Shift"
            ];
            key = "J";
            perCompositor = {
                niri.action.move-window-down = [ ];
            };
        }
        {
            name = "Move Window Up";
            mod = [
                "Super"
                "Shift"
            ];
            key = "K";
            perCompositor = {
                niri.action.move-window-up = [ ];
            };
        }
        {
            name = "Screenshot Monitor";
            key = "Print";
            perCompositor = {
                niri.action.screenshot-screen = [ ];
            };
        }
        {
            name = "Screenshot Window";
            mod = "Super";
            key = "Print";
            perCompositor = {
                niri.action.screenshot-window = [ ];
            };
        }
        {
            name = "Screenshot Region";
            mod = [
                "Super"
                "Shift"
            ];
            key = "Print";
            perCompositor = {
                niri.action.screenshot = [ ];
            };
        }
        {
            name = "Scroll to Next Workspace";
            mod = "Super";
            key = "WheelScrollDown";
            perCompositor = {
                niri = {
                    cooldown-ms = 150;
                    action.focus-workspace-down = [ ];
                };
            };
        }
        {
            name = "Scroll to Prev Workspace";
            mod = "Super";
            key = "WheelScrollUp";
            perCompositor = {
                niri = {
                    cooldown-ms = 150;
                    action.focus-workspace-up = [ ];
                };
            };
        }
        {
            name = "Scroll Layout Right";
            mod = [
                "Super"
                "Shift"
            ];
            key = "WheelScrollDown";
            perCompositor = {
                niri = {
                    cooldown-ms = 150;
                    action.focus-column-right = [ ];
                };
            };
        }
        {
            name = "Scroll Layout Left";
            mod = [
                "Super"
                "Shift"
            ];
            key = "WheelScrollUp";
            perCompositor = {
                niri = {
                    cooldown-ms = 150;
                    action.focus-column-left = [ ];
                };
            };
        }
        {
            name = "Toggle Overview";
            mod = "Super";
            key = "Space";
            perCompositor = {
                niri = {
                    repeat = false;
                    action.toggle-overview = [ ];
                };
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
            [
                {
                    name = "Focus Workspace ${name}";
                    mod = "Super";
                    inherit key;
                    perCompositor = {
                        niri.action.focus-workspace = index;
                    };
                }
                {
                    name = "Move Window to Workspace ${name} and Focus";
                    mod = [
                        "Super"
                        "Shift"
                    ];
                    inherit key;
                    perCompositor = {
                        niri.action.move-window-to-workspace = index;
                    };
                }
                {
                    name = "Move Window to Workspace ${name}";
                    mod = [
                        "Super"
                        "Ctrl"
                    ];
                    inherit key;
                    perCompositor = {
                        niri.action.move-window-to-workspace = [
                            { focus = false; }
                            index
                        ];
                    };
                }
            ]
        ) count
    ));
}
