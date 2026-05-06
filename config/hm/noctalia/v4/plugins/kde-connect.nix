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
    inherit (osConfig.programs.kdeconnect) enable;
in
lib.mkIf (cfg.desktop.enable && (cfg.desktop.shell == "noctalia-legacy")) {
    services.kdeconnect.enable = lib.mkDefault enable;
    programs.noctalia-shell.plugins.states.kde-connect = {
        enabled = lib.mkDefault enable;
        inherit sourceUrl;
    };
    home.packages = lib.optional enable pkgs.kdePackages.qttools;
}
