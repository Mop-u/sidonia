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
    programs.noctalia-shell.settings.sessionMenu = builtins.mapAttrs (n: v: lib.mkDefault v) {
        enableCountdown = true;
        countdownDuration = 10000;
        position = "center";
        showHeader = true;
        showKeybinds = true;
        largeButtonsStyle = true;
        largeButtonsLayout = "single-row";
        powerOptions = [
            {
                action = "lock";
                enabled = true;
                keybind = "1";
            }
            {
                action = "suspend";
                enabled = true;
                keybind = "2";
            }
            {
                action = "hibernate";
                enabled = true;
                keybind = "3";
            }
            {
                action = "reboot";
                enabled = true;
                keybind = "4";
            }
            {
                action = "logout";
                enabled = true;
                keybind = "5";
            }
            {
                action = "shutdown";
                enabled = true;
                keybind = "6";
            }
            {
                action = "rebootToUefi";
                enabled = false;
                keybind = "7";
            }
        ];
    };
}
