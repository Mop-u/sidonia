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
            windowrulev2 = [
                "float,                        class:(io.missioncenter.MissionCenter)"
                "size ${cfg.window.float.wh},  class:(io.missioncenter.MissionCenter)"
                "${cfg.window.float.onCursor}, class:(io.missioncenter.MissionCenter)"
            ];
        };
    };
    sidonia.desktop.keybinds = [
        {
            mod = [
                "super"
                "shift"
            ];
            key = "escape";
            exec = "missioncenter";
        }
    ];
}
