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
lib.mkIf (cfg.desktop.enable && (cfg.desktop.shell == "noctalia-legacy")) {
    programs.noctalia-shell.settings.templates = builtins.mapAttrs (n: v: lib.mkDefault v) {
        activeTemplates = [ ];
        enableUserTheming = false;
    };
}
