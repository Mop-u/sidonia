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
            services.displayManager.defaultSession = lib.mkDefault "hyprland-uwsm";
        })
    ];
}
