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
lib.mkIf (cfg.desktop.enable && (cfg.desktop.shell == "noctalia-legacy")) {
    programs.noctalia-shell.settings.bar = builtins.mapAttrs (n: v: lib.mkDefault v) {
        autoHideDelay = 500;
        autoShowDelay = 150;
        backgroundOpacity = window.decoration.opacity.dec;
        barType = "floating";
        capsuleColorKey = "none";
        capsuleOpacity = 1;
        contentPadding = 2;
        enableExclusionZoneInset = true;
        middleClickAction = "none";
        middleClickCommand = "";
        middleClickFollowMouse = false;
        mouseWheelAction = "none";
        mouseWheelWrap = true;
        reverseScroll = false;
        rightClickAction = "controlCenter";
        rightClickCommand = "";
        rightClickFollowMouse = true;
        density = "comfortable";
        displayMode = "always_visible";
        fontScale = 1;
        frameRadius = 12;
        frameThickness = 8;
        hideOnOverview = false;
        marginHorizontal = 4;
        marginVertical = 4;
        monitors = [ ];
        outerCorners = true;
        position = "top";
        screenOverrides = [ ];
        showCapsule = true;
        showOnWorkspaceSwitch = true;
        showOutline = false;
        useSeparateOpacity = false;
        widgetSpacing = 6;
        widgets = {
            left = [
                {
                    colorizeDistroLogo = false;
                    colorizeSystemIcon = "none";
                    colorizeSystemText = "none";
                    customIconPath = "";
                    enableColorization = false;
                    icon = "noctalia";
                    id = "ControlCenter";
                    useDistroLogo = true;
                }
                {
                    clockColor = "none";
                    customFont = "";
                    formatHorizontal = "HH:mm";
                    formatVertical = "HH mm";
                    id = "Clock";
                    tooltipFormat = "HH:mm ddd; MMM dd";
                    useCustomFont = false;
                }
                {
                    compactMode = false;
                    diskPath = "/";
                    iconColor = "none";
                    id = "SystemMonitor";
                    showCpuCores = false;
                    showCpuFreq = false;
                    showCpuTemp = true;
                    showCpuUsage = false;
                    showDiskAvailable = false;
                    showDiskUsage = false;
                    showDiskUsageAsPercent = false;
                    showGpuTemp = true;
                    showLoadAverage = false;
                    showMemoryAsPercent = true;
                    showMemoryUsage = false;
                    showNetworkStats = true;
                    showSwapUsage = false;
                    textColor = "none";
                    useMonospaceFont = true;
                    usePadding = true;
                }
                {
                    characterCount = 1;
                    colorizeIcons = false;
                    emptyColor = "secondary";
                    enableScrollWheel = false;
                    focusedColor = "primary";
                    followFocusedScreen = false;
                    fontWeight = "bold";
                    groupedBorderOpacity = 1;
                    hideUnoccupied = true;
                    iconScale = 0.8;
                    id = "Workspace";
                    labelMode = "none";
                    occupiedColor = "secondary";
                    pillSize = 0.6;
                    showApplications = true;
                    showApplicationsHover = false;
                    showBadge = true;
                    showLabelsOnlyWhenOccupied = true;
                    unfocusedIconsOpacity = 1;
                }
            ];
            center = [
                {
                    colorizeIcons = false;
                    hideMode = "hidden";
                    id = "ActiveWindow";
                    maxWidth = 600;
                    scrollingMode = "hover";
                    showIcon = true;
                    showText = true;
                    textColor = "none";
                    useFixedWidth = false;
                }
            ];
            right =
                (lib.optional cfg.isLaptop {
                    id = "Battery";
                    deviceNativePath = "__default__";
                    displayMode = "graphic-clean";
                    hideIfIdle = false;
                    showNoctaliaPerformance = false;
                    showPowerProfiles = false;
                })
                ++ (lib.optional (config.programs.noctalia-shell.plugins.states.kde-connect.enabled) {
                    id = "plugin:kde-connect";
                })
                ++ [
                    {
                        displayMode = "onhover";
                        iconColor = "none";
                        id = "Network";
                        textColor = "none";
                    }
                    {
                        displayMode = "onhover";
                        iconColor = "none";
                        id = "Bluetooth";
                        textColor = "none";
                    }
                    {
                        blacklist = [ ];
                        chevronColor = "none";
                        colorizeIcons = false;
                        drawerEnabled = false;
                        hidePassive = false;
                        id = "Tray";
                        pinned = [ ];
                    }
                    {
                        hideWhenZero = false;
                        hideWhenZeroUnread = false;
                        iconColor = "none";
                        id = "NotificationHistory";
                        showUnreadBadge = true;
                        unreadBadgeColor = "primary";
                    }
                    { id = "plugin:keybind-cheatsheet"; }
                ]
                ++ (lib.optional (config.programs.noctalia-shell.plugins.states.screen-recorder.enabled) {
                    id = "plugin:screen-recorder";
                });
        };
    };
}
