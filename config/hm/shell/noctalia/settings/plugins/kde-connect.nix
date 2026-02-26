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
    enableKdeConnect = osConfig.programs.kdeconnect.enable || config.services.kdeconnect.enable;
in
lib.mkIf (cfg.desktop.enable && (cfg.desktop.shell == "noctalia") && enableKdeConnect) {
    services.kdeconnect.enable = lib.mkDefault osConfig.programs.kdeconnect.enable;
    home.packages = [ pkgs.kdePackages.qttools ];
    programs.noctalia-shell.plugins.states.kde-connect = {
        enabled = lib.mkDefault true;
        inherit sourceUrl;
    };
}
