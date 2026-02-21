{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
    lock_cmd = if cfg.graphics.legacyGpu then "swaylock" else "hyprlock";
in
lib.mkIf
    (cfg.desktop.enable && (cfg.desktop.compositor == "hyprland") && (cfg.desktop.shell == "legacy"))
    {
        wayland.desktopManager.sidonia.keybinds = [
            {
                name = "Lock Screen";
                mod = [ "super" ];
                key = "x";
                exec = lock_cmd;
            }
        ];

        programs.hyprlock = {
            enable = !cfg.graphics.legacyGpu;
        };

        programs.swaylock = {
            enable = cfg.graphics.legacyGpu;
        };
    }
