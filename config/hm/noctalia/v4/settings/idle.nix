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
    programs.noctalia-shell.settings.idle = builtins.mapAttrs (n: v: lib.mkDefault v) {
        customCommands = "[]";
        enabled = false;
        fadeDuration = 5;
        lockCommand = "";
        lockTimeout = 660;
        resumeLockCommand = "";
        resumeScreenOffCommand = "";
        screenOffCommand = "";
        screenOffTimeout = 600;
        suspendCommand = "";
        suspendTimeout = 1800;
    };
}
