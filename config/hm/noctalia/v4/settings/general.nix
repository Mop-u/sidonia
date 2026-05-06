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
    programs.noctalia-shell.settings.general = builtins.mapAttrs (n: v: lib.mkDefault v) {
        allowPanelsOnScreenWithoutBar = true;
        allowPasswordWithFprintd = false;
        animationDisabled = false;
        animationSpeed = 1;
        autoStartAuth = false;
        avatarImage = "${config.home.homeDirectory}/.face";
        boxRadiusRatio = 1;
        clockFormat = "hh\\\\nmm";
        clockStyle = "custom";
        compactLockScreen = false;
        dimmerOpacity = 0.2;
        enableBlurBehind = !osConfig.sidonia.graphics.legacyGpu;
        enableLockScreenCountdown = true;
        enableLockScreenMediaControls = false;
        enableShadows = !osConfig.sidonia.graphics.legacyGpu;
        forceBlackScreenCorners = false;
        iRadiusRatio = 1;
        keybinds = {
            keyDown = [ "Down" ];
            keyEnter = [
                "Return"
                "Enter"
            ];
            keyEscape = [ "Esc" ];
            keyLeft = [ "Left" ];
            keyRemove = [ "Del" ];
            keyRight = [ "Right" ];
            keyUp = [ "Up" ];
        };
        language = "";
        lockOnSuspend = true;
        lockScreenAnimations = false;
        lockScreenBlur = 0;
        lockScreenCountdownDuration = 10000;
        lockScreenMonitors = [ ];
        lockScreenTint = 0;
        passwordChars = false;
        radiusRatio = 0.2;
        reverseScroll = false;
        scaleRatio = 1;
        screenRadiusRatio = 1;
        shadowDirection = "bottom_right";
        shadowOffsetX = 2;
        shadowOffsetY = 3;
        showChangelogOnStartup = true;
        showHibernateOnLockScreen = false;
        showScreenCorners = false;
        showSessionButtonsOnLockScreen = true;
        smoothScrollEnabled = true;
        telemetryEnabled = false;
    };
}
