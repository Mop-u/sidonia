{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
    sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
in
lib.mkIf
    (cfg.desktop.enable && (cfg.desktop.shell == "noctalia") && (cfg.desktop.compositor == "hyprland"))
    {
        programs.noctalia-shell = {
            plugins = {
                states = {
                    workspace-overview = {
                        enabled = lib.mkDefault true;
                        inherit sourceUrl;
                    };
                };
            };
        };
        wayland.desktopManager.sidonia.keybinds = [
            {
                name = "Toggle Workspace Overview";
                mod = "Super";
                key = "Tab";
                exec = "noctalia-shell ipc call plugin:workspace-overview toggle";
            }
            {
                name = "Toggle Workspace Overview";
                mod = "Alt";
                key = "Tab";
                exec = "noctalia-shell ipc call plugin:workspace-overview toggle";
            }
        ];
    }
