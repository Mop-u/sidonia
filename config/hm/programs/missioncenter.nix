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
lib.mkIf (cfg.desktop.enable) {
    home.packages = [ pkgs.mission-center ];
    wayland.windowManager.hyprland.settings = {
        windowrule = [
            "match:class io.missioncenter.MissionCenter, float on, size ${cfg.desktop.window.decoration.float.wh}, ${cfg.desktop.window.decoration.float.onCursor}"
        ];
    };
    wayland.desktopManager.sidonia.keybinds = [
        {
            name = "Task Manager";
            mod = [
                "super"
                "shift"
            ];
            key = "escape";
            exec = "missioncenter";
        }
    ];
}
