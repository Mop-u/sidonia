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
lib.mkIf (cfg.desktop.enable && (cfg.desktop.compositor == "hyprland")) {
    wayland.windowManager.hyprland.settings = {
        gesture = [ "3, horizontal, workspace" ];
        binds = {
            scroll_event_delay = 100;
        };
        binde = [
            "SUPERALT, H, resizeactive, -10    0" # resize left
            "SUPERALT, J, resizeactive,   0   10" # resize down
            "SUPERALT, K, resizeactive,   0  -10" # resize up
            "SUPERALT, L, resizeactive,  10    0" # resize right
        ];
        bind =
            (builtins.map (
                x: "${lib.concatStrings x.mod}, ${x.key}, exec, uwsm app -- ${x.exec} #\"${x.name}\""
            ) config.wayland.desktopManager.sidonia.keybinds)
            ++ [
                "SUPERSHIFT, C,         killactive, #\"Close Active Window\""
                "SUPERSHIFT, Q,         exec, uwsm stop #\"Exit Hyprland Session\""

                "SUPER,      V,         togglefloating, #\"Toggle Window Floating\""
                "SUPER,      F,         fullscreen, #\"Toggle Fullscreen\""

                "SUPER,      H,         movefocus, l #\"Move Focus Left\""
                "SUPER,      J,         movefocus, d #\"Move Focus Down\""
                "SUPER,      K,         movefocus, u #\"Move Focus Up\""
                "SUPER,      L,         movefocus, r #\"Move Focus Right\""

                "SUPERSHIFT, H,         swapwindow, l #\"Swap Window Left\""
                "SUPERSHIFT, J,         swapwindow, d #\"Swap Window Down\""
                "SUPERSHIFT, K,         swapwindow, u #\"Swap Window Up\""
                "SUPERSHIFT, L,         swapwindow, r #\"Swap Window Right\""

                "SUPER,      mouse_down,workspace, e+1 #\"Focus Next Workspace\""
                "SUPER,      mouse_up,  workspace, e-1 #\"Focus Previous Workspace\""

                "SUPER,      S,         togglespecialworkspace, magic #\"Toggle Special Workspace\""
                "SUPERSHIFT, S,         movetoworkspace,        special:magic #\"Move Window To Special Workspace\""

                ",           PRINT,     exec, hyprshot -m output -m active --clipboard-only #\"Screenshot Active Monitor\""
                "SUPER,      PRINT,     exec, hyprshot -m window -m active --clipboard-only #\"Screenshot Active Window\""
                "SUPERSHIFT, PRINT,     exec, hyprshot -m region --clipboard-only #\"Screenshot Region\""
            ]
            ++ (builtins.concatLists (
                builtins.genList (
                    x:
                    let
                        c = (x + 1) / 10;
                        ws = builtins.toString (x + 1 - (c * 10));
                    in
                    [
                        "SUPER,          ${ws},workspace,             ${builtins.toString (x + 1)} #\"Focus Workspace ${ws}\""
                        "SUPERSHIFT,     ${ws},movetoworkspace,       ${builtins.toString (x + 1)} #\"Move Window To Workspace ${ws} And Focus\""
                        "SUPERCONTROL,   ${ws},movetoworkspacesilent, ${builtins.toString (x + 1)} #\"Move Window To Workspace ${ws}\""
                        "SUPERCONTROLALT,${ws},moveworkspacetomonitor,${builtins.toString (x + 1)} current #\"Move Workspace To Focused Monitor\""
                        "SUPERCONTROLALT,${ws},workspace,             ${builtins.toString (x + 1)}"
                    ]
                ) 10
            ));
        bindm = [
            "SUPER, mouse:272, movewindow #\"Move Window\""
            "SUPER, mouse:273, resizewindow #\"Resize Window\""
        ];
    };
}
