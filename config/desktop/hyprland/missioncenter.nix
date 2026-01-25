{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
in
lib.mkIf cfg.programs.hyprland.enable {
    home-manager.users.${cfg.userName} = {
        home.packages = [ pkgs.mission-center ];
        wayland.windowManager.hyprland.settings = {
            windowrule = [
                "match:class io.missioncenter.MissionCenter, float on, size ${cfg.desktop.window.decoration.float.wh}, ${cfg.desktop.window.decoration.float.onCursor}"
            ];
        };
    };
    sidonia.desktop.keybinds = [
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
