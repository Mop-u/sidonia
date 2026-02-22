{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
    theme = cfg.style.catppuccin;
in
lib.mkIf (cfg.desktop.enable) {
    catppuccin.kvantum = {
        enable = true;
        apply = true;
    };
    qt = {
        enable = true;
        style.name = "kvantum";
        platformTheme.name = "kvantum";
    };
}
