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
    programs.noctalia-shell.settings.bar = builtins.mapAttrs (n: v: lib.mkDefault v) {
        autoHideDelay = 500;
        autoShowDelay = 150;
        backgroundOpacity = 0.93;
        barType = "framed";
        capsuleColorKey = "none";
        capsuleOpacity = 1;
        density = "comfortable";
        displayMode = "always_visible";
        floating = false;
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
                    customIconPath = "";
                    enableColorization = false;
                    icon = "noctalia";
                    id = "ControlCenter";
                    useDistroLogo = true;
                }
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
                { id = "plugin:keybind-cheatsheet"; }
                {
                    characterCount = 2;
                    colorizeIcons = false;
                    emptyColor = "secondary";
                    enableScrollWheel = true;
                    focusedColor = "primary";
                    followFocusedScreen = false;
                    groupedBorderOpacity = 1;
                    hideUnoccupied = false;
                    iconScale = 0.8;
                    id = "Workspace";
                    labelMode = "index";
                    occupiedColor = "secondary";
                    pillSize = 0.6;
                    showApplications = true;
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
                    textColor = "none";
                    useFixedWidth = false;
                }
            ];
            right =
                (lib.optional cfg.isLaptop {
                    id = "Battery";
                    alwaysShowPercentage = false;
                    warningThreshold = 30;
                })
                ++ [
                    {
                        clockColor = "none";
                        customFont = "";
                        formatHorizontal = "HH:mm";
                        formatVertical = "HH mm";
                        id = "Clock";
                        tooltipFormat = "HH:mm ddd, MMM dd";
                        useCustomFont = false;
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
                ];
        };
    };
}
