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
            };
            version = lib.mkDefault 2;
        };
        settings.plugins = builtins.mapAttrs (n: v: lib.mkDefault v) {
            autoUpdate = false;
            notifyUpdates = true;
        };
    };
}
