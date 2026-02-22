{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
    theme = cfg.style.catppuccin;
in

lib.mkIf (cfg.desktop.enable) (
    lib.mkMerge [
        {
            catppuccin.cursors.enable = true;
            home.pointerCursor = {
                enable = true;
                size = lib.mkDefault 30;
                gtk.enable = true;
                x11.enable = true;
            };
        }
        (lib.mkIf (cfg.desktop.compositor == "hyprland") {
            home.pointerCursor.hyprcursor.enable = true;
            wayland.windowManager.hyprland.settings.cursor.enable_hyprcursor = true;
            home.packages = [ pkgs.hyprcursor ];
        })
    ]
)
