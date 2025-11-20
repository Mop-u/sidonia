{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
    patchedBwrap = pkgs.bubblewrap.overrideAttrs (o: {
        patches = (o.patches or [ ]) ++ [
            (pkgs.writeTextFile {
                name = "bwrap.patch";
                text = ''
                    diff --git a/bubblewrap.c b/bubblewrap.c
                    index 8322ea0..4e20262 100644
                    --- a/bubblewrap.c
                    +++ b/bubblewrap.c
                    @@ -868,13 +868,6 @@ acquire_privs (void)
                           /* Keep only the required capabilities for setup */
                           set_required_caps ();
                         }
                    -  else if (real_uid != 0 && has_caps ())
                    -    {
                    -      /* We have some capabilities in the non-setuid case, which should not happen.
                    -         Probably caused by the binary being setcap instead of setuid which we
                    -         don't support anymore */
                    -      die ("Unexpected capabilities but not setuid, old file caps config?");
                    -    }
                       else if (real_uid == 0)
                         {
                           /* If our uid is 0, default to inheriting all caps; the caller
                '';
            })
        ];
    });
in
{
    options.sidonia.services.vr = {
        enable = lib.mkEnableOption "Enable VR services";
        open.enable = lib.mkEnableOption "Enable SteamVR alternative services";
    };
    config = lib.mkIf (cfg.services.vr.enable) (
        lib.mkMerge [
            {
                hardware.steam-hardware.enable = true;
                programs.steam.extraCompatPackages = [
                    pkgs.proton-ge-rtsp-bin
                ];
                home-manager.users.${cfg.userName} = {
                    home.file = {
                        ".local/share/Steam/ubuntu12_32/steam-runtime/usr/libexec/steam-runtime-tools-0/srt-bwrap" = {
                            source = "${patchedBwrap}/bin/bwrap";
                        };
                    };
                };
                nixpkgs.overlays = [
                    (final: prev: {
                        steam = prev.steam.override {
                            buildFHSEnv = (
                                args:
                                (
                                    (pkgs.buildFHSEnv.override {
                                        bubblewrap = patchedBwrap;
                                    })
                                    (args // { extraBwrapArgs = (args.extraBwrapArgs or [ ]) ++ [ "--cap-add ALL" ]; })
                                )
                            );
                        };
                    })
                ];
            }
            (lib.mkIf (cfg.services.vr.open.enable) {
                services.monado = {
                    enable = true;
                    defaultRuntime = true;
                };
                systemd.user.services.monado.environment = {
                    STEAMVR_LH_ENABLE = "1";
                    XRT_COMPOSITOR_COMPUTE = "1";
                };
                home-manager.users.${cfg.userName} = {
                    home.packages = [
                        pkgs.xrizer
                        pkgs.wlx-overlay-s
                    ];
                    xdg.configFile = {
                        "openxr/1/active_runtime.json".source =
                            "${config.services.monado.package}/share/openxr/1/openxr_monado.json";

                        "openvr/openvrpaths.vrpath".text = builtins.toJSON {
                            config = [ "${config.home-manager.users.${cfg.userName}.xdg.dataHome}/Steam/config" ];
                            external_drivers = null;
                            jsonid = "vrpathreg";
                            log = [ "${config.home-manager.users.${cfg.userName}.xdg.dataHome}/Steam/logs" ];
                            runtime = [ "${pkgs.xrizer}/lib/xrizer" ];
                            version = 1;
                        };
                    };
                    home.file = {
                        ".local/share/monado/hand-tracking-models".source = pkgs.fetchgit {
                            url = "https://gitlab.freedesktop.org/monado/utilities/hand-tracking-models";
                            sha256 = "sha256-x/X4HyyHdQUxn3CdMbWj5cfLvV7UyQe1D01H93UCk+M=";
                            fetchLFS = true;
                        };
                    };
                };
            })
        ]
    );
}
