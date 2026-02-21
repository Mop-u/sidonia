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
    programs.noctalia-shell = {
        enable = true;
        systemd.enable = true;
        settings = {
            # configure noctalia here
            # https://docs.noctalia.dev/getting-started/nixos/#config-ref
            bar = {
                density = "default";
                position = "top";
                showCapsule = true;
                widgets = {
                    left = [
                        {
                            id = "ControlCenter";
                            useDistroLogo = true;
                        }
                        { id = "Network"; }
                        { id = "Bluetooth"; }
                    ];
                    center = [
                        {
                            id = "Workspace";
                            hideUnoccupied = false;
                            labelMode = "index";
                            showApplications = true;
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
                                id = "Clock";
                                formatHorizontal = "HH:mm";
                                formatVertical = "HH mm";
                                useMonospacedFont = true;
                                usePrimaryColor = true;
                            }
                            {
                                id = "Tray";
                                drawerEnabled = false;
                            }
                            { id = "NotificationHistory"; }
                        ];
                };
            };
            colorSchemes.predefinedScheme = "Catppuccin";
            general = {
                avatarImage = "${config.home.homeDirectory}/.face";
                radiusRatio = 0.2;
            };
            location.name = "Dublin";
        };
        # this may also be a string or a path to a JSON file.
    };
    wayland.desktopManager.sidonia.keybinds =
        let
            noctalia = args: "noctalia-shell ipc call ${args}";
        in
        [
            {
                name = "Toggle Launcher";
                mod = [ "super" ];
                key = "p";
                exec = noctalia "launcher toggle";
            }
            {
                name = "Toggle Session Menu";
                mod = [ "super" ];
                key = "m";
                exec = noctalia "sessionMenu toggle";
            }
            {
                name = "Lock Screen";
                mod = [ "super" ];
                key = "x";
                exec = noctalia "lockScreen lock";
            }
            {
                name = "Volume Up";
                key = "XF86AudioRaiseVolume";
                exec = noctalia "volume increase";
            }
            {
                name = "Volume Down";
                key = "XF86AudioLowerVolume";
                exec = noctalia "volume decrease";
            }
            {
                name = "Mute Output";
                key = "XF86AudioMute";
                exec = noctalia "volume muteOutput";
            }
            {
                name = "Mute Input";
                key = "XF86AudioMicMute";
                exec = noctalia "volume muteInput";
            }
            {
                name = "Media Play";
                key = "XF86AudioPlay";
                exec = noctalia "media play";
            }
            {
                name = "Media Pause";
                key = "XF86AudioPause";
                exec = noctalia "media pause";
            }
            {
                name = "Media Next";
                key = "XF86AudioNext";
                exec = noctalia "media next";
            }
            {
                name = "Media Prev";
                key = "XF86AudioPrev";
                exec = noctalia "media previous";
            }
            {
                name = "Brightness Up";
                key = "XF86MonBrightnessUp";
                exec = noctalia "brightness increase";
            }
            {
                name = "Brightness Down";
                key = "XF86MonBrightnessDown";
                exec = noctalia "brightness decrease";
            }
        ];
}
