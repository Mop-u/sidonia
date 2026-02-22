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
lib.mkIf
    (cfg.desktop.enable && (cfg.desktop.compositor == "hyprland") && (cfg.desktop.shell == "legacy"))
    {
        services.hyprpolkitagent.enable = true;
    }
