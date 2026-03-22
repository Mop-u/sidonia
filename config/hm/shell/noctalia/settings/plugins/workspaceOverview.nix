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
            pluginSettings = {
                workspace-overview = builtins.mapAttrs (n: v: lib.mkDefault v) {
                    gridRows = 2;
                    gridColumns = 5;
                    gridScale = 0.16;
                    hideEmptyRows = true;
                    showScratchpadWorkspace = false;
                    gridSpacing = 0;
                    overviewPosition = "center";
                    barmargin = 0;
                    useSlideAnimation = true;
                    containerBorderWidth = -1;
                    selectionBorderWidth = -1;
                    accentColorType = "secondary";
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
            {
                name = "Toggle Workspace Overview";
                mod = "Super";
                key = "Space";
                exec = "noctalia-shell ipc call plugin:workspace-overview toggle";
            }
        ];
    }
