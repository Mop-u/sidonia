{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
in
lib.mkIf (cfg.desktop.enable) {
    sidonia.desktop.keybinds = [
        {
            name = "Terminal";
            mod = [
                "super"
                "shift"
            ];
            key = "return";
            exec = "foot";
        }
    ];
    xdg.terminal-exec = {
        enable = true;
        settings.default = [ "foot.desktop" ];
    };
    home-manager.users.${config.sidonia.userName} = {
        catppuccin.foot.enable = true;
        programs.foot = {
            enable = true;
            settings = {
                # https://codeberg.org/dnkl/foot/src/branch/master/foot.ini
                main.dpi-aware = "no";
                main.font = "monospace:size=10";
                colors.alpha = builtins.toString cfg.desktop.window.decoration.opacity.dec;
            };
        };
        wayland.windowManager.hyprland.settings = {
            windowrule = [
                "float,                        class:(foot), title:(foot)"
                "size ${cfg.desktop.window.decoration.float.wh},  class:(foot), title:(foot)"
                "${cfg.desktop.window.decoration.float.onCursor}, class:(foot), title:(foot)"
            ];
        };
    };
}
