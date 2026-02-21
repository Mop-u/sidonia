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
    programs.noctalia-shell.settings.dock = {
        enabled = true;
        position = "bottom";
        displayMode = "auto_hide";
        dockType = "static";
        backgroundOpacity = 1;
        floatingRatio = 1;
        size = 2;
        onlySameOutput = false;
        monitors = [ ];
        pinnedApps = [ ];
        colorizeIcons = false;
        showLauncherIcon = false;
        launcherPosition = "start";
        pinnedStatic = false;
        inactiveIndicators = false;
        groupApps = true;
        groupContextMenuMode = "extended";
        groupClickAction = "cycle";
        groupIndicatorStyle = "dots";
        deadOpacity = 0.6;
        animationSpeed = 1;
        sitOnFrame = true;
        showFrameIndicator = true;
    };
}
