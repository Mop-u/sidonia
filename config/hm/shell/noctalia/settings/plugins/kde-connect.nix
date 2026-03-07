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
lib.mkIf (cfg.desktop.enable && (cfg.desktop.shell == "noctalia")) (
    lib.mkMerge [
        { services.kdeconnect.enable = lib.mkDefault osConfig.programs.kdeconnect.enable; }
        (lib.mkIf osConfig.programs.kdeconnect.enable {
            home.packages = [ pkgs.kdePackages.qttools ];
            programs.noctalia-shell.plugins.states.kde-connect = {
                enabled = lib.mkDefault true;
                inherit sourceUrl;
            };
        })
    ]
)
