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
    programs.noctalia-shell.settings.ui = builtins.mapAttrs (n: v: lib.mkDefault v) {
        fontDefault = "";
        fontFixed = "";
        fontDefaultScale = 1;
        fontFixedScale = 1;
        tooltipsEnabled = true;
        panelBackgroundOpacity = 0.93;
        panelsAttachedToBar = true;
        settingsPanelMode = "attached";
        boxBorderEnabled = false;
        scrollbarAlwaysVisible = true;
        settingsPanelSideBarCardStyle = false;
        translucentWidgets = false;
    };
}
