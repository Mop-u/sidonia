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
            "Super,       M,          layoutmsg, fit visible #\"Fit Visible Windows to Monitor\""

            "Super, mouse_down, split-cycleworkspaces, prev #\"Scroll to Next Workspace\""
            "Super, mouse_up,   split-cycleworkspaces, next #\"Scroll to Prev Workspace\""

            "Super Shift, mouse_down, layoutmsg, move -col #\"Scroll Layout Right\""
            "Super Shift, mouse_up,   layoutmsg, move +col #\"Scroll Layout Left\""

            "Super, G, split-grabroguewindows #\"Grab Orphaned Windows (e.g. From Disconnected Monitor)\""

            "Super,       S,         togglespecialworkspace, magic #\"Toggle Special Workspace\""
            "Super Shift, S,         movetoworkspace,        special:magic #\"Move Window To Special Workspace\""
        ];
        bindm = [
            "Super, ${mouse.left}, movewindow #\"(Hold) Move Window\""
            "Super, ${mouse.right}, resizewindow #\"(Hold) Resize Window\""
        ];
        bindc = [
            "Super, ${mouse.left}, layoutmsg, promote #\"(Click) Promote Window to Its Own Column\""
        ];
    };
}
