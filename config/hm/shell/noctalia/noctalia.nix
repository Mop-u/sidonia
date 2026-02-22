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
lib.mkIf (cfg.desktop.enable && (cfg.desktop.shell == "noctalia")) {
    programs.noctalia-shell = {
        enable = true;
        systemd.enable = true;
        settings.settingsVersion = 53;
        package = pkgs.noctalia-shell.override {
            quickshell = pkgs.quickshell-git.unwrapped;
        };
    };
}
