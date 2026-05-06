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
    programs.noctalia-shell.settings.systemMonitor = builtins.mapAttrs (n: v: lib.mkDefault v) {
        cpuWarningThreshold = 80;
        cpuCriticalThreshold = 90;
        tempWarningThreshold = 80;
        tempCriticalThreshold = 90;
        gpuWarningThreshold = 80;
        gpuCriticalThreshold = 90;
        memWarningThreshold = 80;
        memCriticalThreshold = 90;
        swapWarningThreshold = 80;
        swapCriticalThreshold = 90;
        diskWarningThreshold = 80;
        diskCriticalThreshold = 90;
        diskAvailWarningThreshold = 20;
        diskAvailCriticalThreshold = 10;
        batteryWarningThreshold = 20;
        batteryCriticalThreshold = 5;
        enableDgpuMonitoring = !cfg.isLaptop;
        useCustomColors = false;
        warningColor = "";
        criticalColor = "";
        externalMonitor = lib.concatStringsSep " || " [
            "resources"
            "missioncenter"
            "jdsystemmonitor"
            "corestats"
            "system-monitoring-center"
            "gnome-system-monitor"
            "plasma-systemmonitor"
            "mate-system-monitor"
            "ukui-system-monitor"
            "deepin-system-monitor"
            "pantheon-system-monitor"
        ];
    };
}
