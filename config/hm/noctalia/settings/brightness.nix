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
    programs.noctalia-shell.settings.brightness = builtins.mapAttrs (n: v: lib.mkDefault v) {
        brightnessStep = 5;
        enforceMinimum = true;
        enableDdcSupport = true;
    };
}
