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
    xdg.terminal-exec = {
        enable = true;
        settings.default = [ "foot.desktop" ];
    };
    dconf.settings = with lib.gvariant; {
        "org/cinnamon/desktop/default-applications/terminal" = {
            exec = mkValue "foot";
            exec-arg = mkValue "-e";
        };
        "org/gnome/desktop/applications/terminal" = {
            exec = mkValue "foot";
            exec-arg = mkValue "-e";
        };
    };
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
            "match:class foot, match:title foot, float on, size ${cfg.desktop.window.decoration.float.wh}, ${cfg.desktop.window.decoration.float.onCursor}"
        ];
    };
    wayland.desktopManager.sidonia.keybinds = [
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
}
