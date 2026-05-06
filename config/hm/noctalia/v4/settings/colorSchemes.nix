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
    programs.noctalia-shell.settings.colorSchemes = builtins.mapAttrs (n: v: lib.mkDefault v) {
        useWallpaperColors = false;
        predefinedScheme = "Catppuccin";
        darkMode = true;
        schedulingMode = "off";
        syncGsettings = true;
        manualSunrise = "06:30";
        manualSunset = "18:30";
        generationMethod = "tonal-spot";
        monitorForColors = "";
    };
}
