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
lib.mkIf (cfg.desktop.enable && (cfg.desktop.compositor == "hyprland")) {
    systemd.user.services.hyprshell.Service.Environment = lib.mapAttrsToList (
        n: v: "${n}=${v}"
    ) cfg.desktop.environment.hyprland;
    programs.hyprshell = {
        enable = true;
        systemd.args = "-v";
        settings = {
            windows = {
                enable = true;
                overview = {
                    enable = true;
                    key = "p";
                    modifier = "super";
                    launcher = {
                        default_terminal = "foot";
                        max_items = 6;
                        plugins = {
                            shell.enable = true;
                            terminal.enable = false;
                        };
                    };
                };
                switch = {
                    enable = false;
                    modifier = "super";
                };
            };
        };
    };
}
