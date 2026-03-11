{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
    mouse = builtins.mapAttrs (n: v: "mouse:${builtins.toString v}") {
        left = 272;
        right = 273;
        middle = 274;
        side = 275;
        extra = 276;
    };
in
lib.mkIf (cfg.desktop.enable && (cfg.desktop.compositor == "hyprland")) {
    wayland.windowManager.hyprland.settings = {
        gesture = [
            "3, up, dispatcher, split-cycleworkspaces, next"
            "3, down, dispatcher, split-cycleworkspaces, prev"
            "3, right, dispatcher, layoutmsg, move -col"
            "3, left, dispatcher, layoutmsg, move +col"
        ];
        binde = [
            "Super Alt, J, resizeactive,   0   10" # resize down
            "Super Alt, K, resizeactive,   0  -10" # resize up
        ];
        bind = [
            "Super Shift, C,          killactive, #\"Close Active Window\""
            "Super, ${mouse.middle},  killactive, #\"Close Active Window\""
            "Super Shift, Q,          exec, uwsm stop #\"Exit Hyprland Session\""

            "Super,       V,          togglefloating, #\"Toggle Window Floating\""
            "Super Shift, F,          fullscreen, #\"Toggle Fullscreen\""
            "Super,       M,          layoutmsg, fit visible #\"Fit Visible Windows to Monitor\""

            "Super,       H,          layoutmsg, focus l #\"Move Focus Left\""
            "Super,       L,          layoutmsg, focus r #\"Move Focus Right\""
            "Super Shift, H,          layoutmsg, swapcol l #\"Move Column Left\""
            "Super Shift, L,          layoutmsg, swapcol r #\"Move Column Right\""
            "Super Alt,   H,          layoutmsg, colresize -conf #\"Decrease Column Width\""
            "Super Alt,   L,          layoutmsg, colresize +conf #\"Increase Column Width\""

            "Super,       J,          layoutmsg, focus d #\"Move Focus Down\""
            "Super,       K,          layoutmsg, focus u #\"Move Focus Up\""
            "Super Shift, J,          swapwindow, d #\"Move Window Down\""
            "Super Shift, K,          swapwindow, u #\"Move Window Up\""

            "Super, mouse_down, split-cycleworkspaces, prev #\"Scroll to Next Workspace\""
            "Super, mouse_up,   split-cycleworkspaces, next #\"Scroll to Prev Workspace\""

            "Super Shift, mouse_down, layoutmsg, move -col #\"Scroll Layout Right\""
            "Super Shift, mouse_up,   layoutmsg, move +col #\"Scroll Layout Left\""

            "Super, G, split-grabroguewindows #\"Grab Orphaned Windows (e.g. From Disconnected Monitor)\""

            "Super,       S,         togglespecialworkspace, magic #\"Toggle Special Workspace\""
            "Super Shift, S,         movetoworkspace,        special:magic #\"Move Window To Special Workspace\""

            ",            PRINT, exec, hyprshot -m output -m active --clipboard-only #\"Screenshot Active Monitor\""
            "Super,       PRINT, exec, hyprshot -m window -m active --clipboard-only #\"Screenshot Active Window\""
            "Super Shift, PRINT, exec, hyprshot -m region --clipboard-only #\"Screenshot Region\""
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
                    "Super,         ${key},split-workspace,             ${name} #\"Focus Workspace ${name}\""
                    "Super Shift,   ${key},split-movetoworkspace,       ${name} #\"Move Window To Workspace ${name} And Focus\""
                    "Super Control, ${key},split-movetoworkspacesilent, ${name} #\"Move Window To Workspace ${name}\""
                ]
            ) count
        ));
        bindm = [
            "Super, ${mouse.left}, movewindow #\"(Hold) Move Window\""
            "Super, ${mouse.right}, resizewindow #\"(Hold) Resize Window\""
        ];
        bindc = [
            "Super, ${mouse.left}, layoutmsg, promote #\"(Click) Promote Window to Its Own Column\""
        ];
    };
}
