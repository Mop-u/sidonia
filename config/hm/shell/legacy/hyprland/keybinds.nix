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
lib.mkIf
    (cfg.desktop.enable && (cfg.desktop.compositor == "hyprland") && (cfg.desktop.shell == "legacy"))
    {
        wayland.windowManager.hyprland = {
            settings = {
                bindel = [
                    ", XF86AudioRaiseVolume,  exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@   5%+"
                    ", XF86AudioLowerVolume,  exec, wpctl set-volume      @DEFAULT_AUDIO_SINK@   5%-"
                    ", XF86AudioMute,         exec, wpctl set-mute        @DEFAULT_AUDIO_SINK@   toggle"
                    ", XF86AudioMicMute,      exec, wpctl set-mute        @DEFAULT_AUDIO_SOURCE@ toggle"
                    ", XF86MonBrightnessUp,   exec, brightnessctl s 10%+"
                    ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
                ];
                bindl = [
                    ", XF86AudioNext,  exec, playerctl next"
                    ", XF86AudioPause, exec, playerctl play-pause"
                    ", XF86AudioPlay,  exec, playerctl play-pause"
                    ", XF86AudioPrev,  exec, playerctl previous"
                ];
            };
        };
    }
