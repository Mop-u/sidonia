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
    inherit (osConfig.programs.gpu-screen-recorder) enable;
in
lib.mkIf (cfg.desktop.enable && (cfg.desktop.shell == "noctalia")) {
    # https://github.com/noctalia-dev/noctalia-plugins/tree/main/screen-recorder
    programs.noctalia-shell = {
        plugins.states.screen-recorder = {
            enabled = lib.mkDefault enable;
            inherit sourceUrl;
        };
        #pluginSettings.screen-recorder = {};
    };
    home.packages = lib.optional enable osConfig.programs.gpu-screen-recorder.package;
}
