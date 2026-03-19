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
lib.mkIf (cfg.desktop.enable && (cfg.desktop.compositor == "niri")) {
    programs.niri.settings.binds = lib.mkMerge [
        {
            "Super+Space" = {
                hotkey-overlay.title = "Toggle Overview";
                repeat = false;
                action.toggle-overview = [ ];
            };

            "Super+WheelScrollDown" = {
                hotkey-overlay.title = "Scroll to Next Workspace";
                cooldown-ms = 150;
                action.focus-workspace-down = [ ];
            };
            "Super+WheelScrollUp" = {
                hotkey-overlay.title = "Scroll to Prev Workspace";
                cooldown-ms = 150;
                action.focus-workspace-up = [ ];
            };
            "Super+Shift+WheelScrollDown" = {
                hotkey-overlay.title = "Scroll Layout Right";
                cooldown-ms = 150;
                action.focus-column-right = [ ];
            };
            "Super+Shift+WheelScrollUp" = {
                hotkey-overlay.title = "Scroll Layout Left";
                cooldown-ms = 150;
                action.focus-column-left = [ ];
            };
        }
    ];
}
