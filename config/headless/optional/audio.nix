{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
in
{
    options.sidonia.tweaks.audio = {
        enable =
            with lib;
            mkOption {
                type = types.bool;
                default = cfg.graphics.enable;
            };
        lowLatency.enable = lib.mkEnableOption "enable low latency audio tweaks for gaming";
    };
    config = lib.mkIf cfg.tweaks.audio.enable (
        lib.mkMerge [
            (lib.mkIf cfg.tweaks.audio.lowLatency.enable {
                services.pipewire.extraConfig = {
                    pipewire."92-low-latency" = {
                        "context.properties" = {
                            "default.clock.rate" = 48000;
                            "default.clock.quantum" = 32;
                            "default.clock.min-quantum" = 32;
                            "default.clock.max-quantum" = 32;
                        };
                    };
                    pipewire-pulse."92-low-latency" = {
                        context.modules = [
                            {
                                name = "libpipewire-module-protocol-pulse";
                                args = {
                                    pulse.min.req = "32/48000";
                                    pulse.default.req = "32/48000";
                                    pulse.max.req = "32/48000";
                                    pulse.min.quantum = "32/48000";
                                    pulse.max.quantum = "32/48000";
                                };
                            }
                        ];
                        stream.properties = {
                            node.latency = "32/48000";
                            resample.quality = 1;
                        };
                    };
                };
            })
            (lib.mkIf (!cfg.tweaks.audio.lowLatency.enable) {
                # increase output headroom.  this may make latency worse (not sure how
                # noticeably) -- so if you game you may want to first try doing
                # without it
                services.pipewire.wireplumber.extraScripts."99-alsa-config" = ''
                    -- prepend, otherwise the change-nothing stock config will match first:
                    table.insert(alsa_monitor.rules, 1, {
                        matches = {
                        {
                            -- Matches all sinks.
                            { "node.name", "matches", "alsa_output.*" },
                        },
                        },
                        apply_properties = {
                        ["api.alsa.headroom"] = 1024,
                        },
                    })
                '';
            })
            {
                # https://cmm.github.io/soapbox/the-year-of-linux-on-the-desktop.html
                services = {
                    # expose important timers etc. to "audio"
                    udev.extraRules = ''
                        DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
                        DEVPATH=="/devices/virtual/misc/hpet", OWNER="root", GROUP="audio", MODE="0660"
                    '';
                    pulseaudio.enable = false; # using pipewire instead
                    pipewire = {
                        enable = true;
                        audio.enable = true;
                        alsa = {
                            enable = true;
                            support32Bit = true;
                        };
                        pulse.enable = true;
                        # explicitly set Pipewire RT params (may not be necessary)
                        extraConfig.pipewire."99-rtparams" = {
                            "context.modules" = [
                                {
                                    name = "libpipewire-module-rt";
                                    args = {
                                        "nice.level" = -11;
                                        "rt.prio" = 19;
                                    };
                                }
                            ];
                        };
                    };
                };

                # Audio stutter prevention
                boot.kernelParams = [ "threadirqs" ];
                security.rtkit.enable = true;

                # allow members of "audio" to set RT priorities up to 90
                security.pam.loginLimits = [
                    {
                        domain = "@audio";
                        type = "-";
                        item = "rtprio";
                        value = "90";
                    }
                ];

                users.users.${cfg.userName}.extraGroups = [
                    "audio"
                    "rtkit"
                ];
            }
        ]
    );
}
