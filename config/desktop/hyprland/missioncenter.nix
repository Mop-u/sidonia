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
                "float,                        class:(io.missioncenter.MissionCenter)"
                "size ${cfg.window.float.wh},  class:(io.missioncenter.MissionCenter)"
                "${cfg.window.float.onCursor}, class:(io.missioncenter.MissionCenter)"
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
