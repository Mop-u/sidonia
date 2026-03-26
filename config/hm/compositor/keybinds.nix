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
                hyprland = "killactive";
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
                hyprland = "killactive";
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
                hyprland = "exec, uwsm stop";
            };
        }
        {
            name = "Toggle Window Floating";
            mod = "Super";
            key = "V";
            perCompositor = {
                niri.action.toggle-window-floating = [ ];
                hyprland = "togglefloating";
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
                hyprland = "layoutmsg, fit active";
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
                hyprland = "layoutmsg, fit visible";
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
                hyprland = "fullscreen";
            };
        }
        {
            name = "Move Focus Left";
            mod = "Super";
            key = "H";
            perCompositor = {
                niri.action.focus-column-left = [ ];
                hyprland = "layoutmsg, focus l";
            };
        }
        {
            name = "Move Focus Right";
            mod = "Super";
            key = "L";
            perCompositor = {
                niri.action.focus-column-right = [ ];
                hyprland = "layoutmsg, focus r";
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
                hyprland = "layoutmsg, swapcol l";
            };
        }
        {
            name = "Move Column Left";
            mod = "Super";
            key = "MouseForward";
            perCompositor = {
                niri.action.move-column-left = [ ];
                hyprland = "layoutmsg, swapcol l";
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
                hyprland = "layoutmsg, swapcol r";
            };
        }
        {
            name = "Move Column Right";
            mod = "Super";
            key = "MouseBack";
            perCompositor = {
                niri.action.move-column-right = [ ];
                hyprland = "layoutmsg, swapcol r";
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
                hyprland = "layoutmsg, colresize -conf";
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
                hyprland = "layoutmsg, colresize -conf";
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
                hyprland = "layoutmsg, colresize +conf";
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
                hyprland = "layoutmsg, colresize +conf";
            };
        }
        {
            name = "Move Focus Down";
            mod = "Super";
            key = "J";
            perCompositor = {
                niri.action.focus-window-down = [ ];
                hyprland = "layoutmsg, focus d";
            };
        }
        {
            name = "Move Focus Up";
            mod = "Super";
            key = "K";
            perCompositor = {
                niri.action.focus-window-up = [ ];
                hyprland = "layoutmsg, focus u";
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
                hyprland = "swapwindow, d";
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
                hyprland = "swapwindow, u";
            };
        }
        {
            name = "Screenshot Monitor";
            key = "Print";
            perCompositor = {
                niri.action.screenshot-screen = [ ];
                hyprland = "exec, hyprshot -m output -m active --clipboard-only";
            };
        }
        {
            name = "Screenshot Window";
            mod = "Super";
            key = "Print";
            perCompositor = {
                niri.action.screenshot-window = [ ];
                hyprland = "exec, hyprshot -m window -m active --clipboard-only";
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
                hyprland = "exec, hyprshot -m region --clipboard-only";
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
                hyprland = "split-cycleworkspaces, prev";
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
                hyprland = "split-cycleworkspaces, next";
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
                hyprland = "layoutmsg, move -col";
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
                hyprland = "layoutmsg, move +col";
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
                        hyprland = "split-workspace, ${name}";
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
                        hyprland = "split-movetoworkspace, ${name}";
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
                        hyprland = "split-movetoworkspacesilent, ${name}";
                    };
                }
            ]
        ) count
    ));
}
