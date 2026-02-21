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
lib.mkIf (cfg.desktop.enable && (cfg.desktop.shell == "legacy")) {
    home.packages = with pkgs; [
        pwvucontrol
        qpwgraph
        brightnessctl
    ];
}
