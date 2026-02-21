{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
    lock_cmd = if cfg.graphics.legacyGpu then "swaylock" else "hyprlock";
in
lib.mkIf
    (cfg.desktop.enable && (cfg.desktop.compositor == "hyprland") && (cfg.desktop.shell == "legacy"))
    {
        services.hypridle = {
            enable = true;
            settings = {
                general = {
                    inherit lock_cmd;
                    before_sleep_cmd = "loginctl lock-session";
                    after_cleep_cmd = "hyprctl dispatch dpms on"; # todo: check lid switch
                };
                listener = [
                    {
                        timeout = 180;
                        on-timeout = "brightnessctl -s set 15%";
                        on-resume = "brightnessctl -r";
                    }
                    #{
                    #    timeout = 180;
                    #    on-timeout = "brightnessctl -sd platform::kbd_backlight set 0";
                    #    on-resume = "brightnessctl -rd platform::kbd_backlight";
                    #}
                    {
                        timeout = 300;
                        on-timeout = "loginctl lock-session";
                    }
                    #{
                    #    timeout = 350;
                    #    on-timeout = "hyprctl dispatch dpms off";
                    #    on-resume = "hyprctl dispatch dpms on"; # todo: check lid switch
                    #}
                    #{
                    #    timeout = 420;
                    #    on-timeout = "systemctl suspend"; # todo: check if docked/charging first
                    #}
                ];
            };
        };
    }
