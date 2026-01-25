{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
    theme = cfg.style.catppuccin;
in
{
    config = lib.mkMerge [
        (lib.mkIf (cfg.desktop.enable) {
            services.displayManager = {
                autoLogin.enable = lib.mkDefault false;
                autoLogin.user = cfg.userName;
                cosmic-greeter.enable = lib.mkDefault true;
            };
        })
        (lib.mkIf (cfg.programs.hyprland.enable) {
            services.displayManager = {
                # https://github.com/hyprwm/Hyprland/discussions/12661
                sessionPackages = [
                    (pkgs.writeTextFile {
                        name = "hyprland-uwsm-fixed";
                        text = ''
                            [Desktop Entry]
                            Name=Hyprland (UWSM)
                            Comment=Hyprland compositor managed by UWSM
                            Exec=${lib.getExe config.programs.uwsm.package} start -F -- /run/current-system/sw/bin/start-hyprland
                            Type=Application
                            DesktopNames=Hyprland
                            Keywords=tiling;wayland;compositor;
                        '';
                        destination = "/share/wayland-sessions/hyprland-uwsm-fixed.desktop";
                        derivationArgs = {
                            passthru.providedSessions = [ "hyprland-uwsm-fixed" ];
                        };
                    })
                ];
                defaultSession = lib.mkDefault "hyprland-uwsm-fixed";
            };
        })
    ];
}
