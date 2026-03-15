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
            "Super+MouseMiddle" = {
                hotkey-overlay.title = "Close Active Window";
                repeat = false;
                action.close-window = [ ];
            };

            "Super+F" = {
                hotkey-overlay.title = "Maximize Column";
                action.maximize-column = [ ];
            };
            "Super+Ctrl+F" = {
                hotkey-overlay.title = "Expand Column to Available Width";
                action.expand-column-to-available-width = [ ];
            };
            "Super+Shift+V" = {
                hotkey-overlay.title = "Switch Focus Between Floating And Tiling";
                action.switch-focus-between-floating-and-tiling = [ ];
            };

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
