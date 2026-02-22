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
        plugins = {
            sources = [
                {
                    enabled = true;
                    name = "Official Noctalia Plugins";
                    url = "https://github.com/noctalia-dev/noctalia-plugins";
                }
            ];
            states = {
                polkit-agent = {
                    enabled = lib.mkDefault true;
                    sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
                };
            };
            version = lib.mkDefault 2;
        };
        settings.plugins = builtins.mapAttrs (n: v: lib.mkDefault v) {
            autoUpdate = true;
        };
    };
}
