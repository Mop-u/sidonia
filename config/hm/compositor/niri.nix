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
    programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
        settings = {
            # see: https://github.com/linuxmobile/kaku/blob/niri/home/software/wayland/niri/settings.nix
            # see: https://github.com/sodiboo/niri-flake/blob/main/docs.md
            # see: https://github.com/niri-wm/niri/blob/main/resources/default-config.kdl
            environment = cfg.desktop.environment.niri;
            xwayland-satellite.enable = true;
            binds = lib.mkMerge (
                (builtins.map (x: {
                    "${lib.concatstringsSep "+" (x.mod ++ [ x.key ])}" = {
                        hotkey-overlay.title = x.name;
                        action.spawn = pkgs.writeScript x.name x.exec;
                    };
                }) config.wayland.desktopManager.sidonia.keybinds)
                ++ [
                    {
                        "Super+Shift+C" = {
                            hotkey-overlay.title = "Close Active Window";
                            action.close-window = { };
                        };
                        "Super+Shift+Q" = {
                            hotkey-overlay.title = "Exit Niri Session";
                            action.quit = { };
                        };
                        "Super+V" = {
                            hotkey-overlay.title = "Toggle Window Floating";
                            action.toggle-window-floating = { };
                        };
                        "Super+Shift+V" = {
                            hotkey-overlay.title = "Switch Focus Between Floating And Tiling";
                            action.switch-focus-between-floating-and-tiling = { };
                        };
                        "Print" = {
                            hotkey-overlay.title = "Screenshot Screen";
                            action.screenshot-screen = { };
                        };
                        "Super+Print" = {
                            hotkey-overlay.title = "Screenshot Window";
                            action.screenshot-window = { };
                        };
                        "Super+Shift+Print" = {
                            hotkey-overlay.title = "Interactive Screenshot";
                            action.screenshot = { };
                        };
                    }
                ]
                ++ (builtins.concatLists (
                    builtins.genList (
                        x:
                        let
                            c = (x + 1) / 10;
                            ws = builtins.toString (x + 1 - (c * 10));
                        in
                        {
                            "Super+${ws}" = {
                                hotkey-overlay.title = "Focus Workspace ${ws}";
                                action.focus-workspace = ws;
                            };
                            "Super+Shift+${ws}" = {
                                hotkey-overlay.title = "Move Window To Workspace ${ws}";
                                action.move-window-to-workspace = ws;
                            };
                        }
                    ) 10
                ))
            );
        };
    };
}
