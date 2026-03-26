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
