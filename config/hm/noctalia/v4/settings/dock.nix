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
    programs.noctalia-shell.settings.dock = builtins.mapAttrs (n: v: lib.mkDefault v) {
        enabled = false;
        position = "bottom";
        displayMode = "auto_hide";
        dockType = "attached";
        backgroundOpacity = 1;
        floatingRatio = 1;
        size = 2;
        onlySameOutput = false;
        monitors = [ ];
        pinnedApps = [ ];
        colorizeIcons = false;
        showLauncherIcon = false;
        launcherIconColor = "none";
        launcherPosition = "start";
        pinnedStatic = false;
        inactiveIndicators = false;
        indicatorColor = "primary";
        indicatorOpacity = 0.6;
        indicatorThickness = 3;
        groupApps = true;
        groupContextMenuMode = "extended";
        groupClickAction = "cycle";
        groupIndicatorStyle = "dots";
        launcherIcon = "";
        launcherUseDistroLogo = true;
        showDockIndicator = false;
        deadOpacity = 0.6;
        animationSpeed = 1;
        sitOnFrame = true;
    };
}
