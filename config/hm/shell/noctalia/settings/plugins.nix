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
lib.mkIf (cfg.desktop.enable && (cfg.desktop.shell == "noctalia")) {
    home.packages = (
        lib.optional (
            osConfig.programs.kdeconnect.enable || config.services.kdeconnect.enable
        ) pkgs.kdePackages.qttools
    );
    services.kdeconnect.enable = lib.mkDefault osConfig.programs.kdeconnect.enable;
    programs.noctalia-shell = {
        plugins = {
            sources = [
                {
                    enabled = true;
                    name = "Official Noctalia Plugins";
                    url = sourceUrl;
                }
            ];
            states = {
                polkit-agent = {
                    enabled = lib.mkDefault true;
                    inherit sourceUrl;
                };
                kaomoji-provider = {
                    enabled = lib.mkDefault true;
                    inherit sourceUrl;
                };
                keybind-cheatsheet = {
                    enabled = lib.mkDefault true;
                    inherit sourceUrl;
                };
                kde-connect = {
                    enabled = lib.mkDefault (osConfig.programs.kdeconnect.enable || config.services.kdeconnect.enable);
                    inherit sourceUrl;
                };
            };
            version = lib.mkDefault 2;
        };
        settings.plugins = builtins.mapAttrs (n: v: lib.mkDefault v) {
            autoUpdate = true;
        };
    };
}
