{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
in
lib.mkIf (cfg.desktop.enable && (cfg.desktop.shell == "legacy")) {
    blueman.enable = true;
}
