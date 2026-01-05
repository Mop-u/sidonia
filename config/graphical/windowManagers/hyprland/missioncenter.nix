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
    home-manager.users.${cfg.userName}.home.packages = [ pkgs.mission-center ];
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
