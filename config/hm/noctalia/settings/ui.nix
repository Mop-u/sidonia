{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
    inherit (config.wayland.desktopManager.sidonia) window;
in
lib.mkIf (cfg.desktop.enable && (cfg.desktop.shell == "noctalia")) {
    programs.noctalia-shell.settings.ui = builtins.mapAttrs (n: v: lib.mkDefault v) {
        fontDefault = "";
        fontFixed = "";
        fontDefaultScale = 1;
        fontFixedScale = 1;
        tooltipsEnabled = true;
        panelBackgroundOpacity = window.decoration.opacity.dec;
        panelsAttachedToBar = true;
        settingsPanelMode = "attached";
        boxBorderEnabled = false;
        scrollbarAlwaysVisible = true;
        settingsPanelSideBarCardStyle = false;
        translucentWidgets = false;
    };
}
