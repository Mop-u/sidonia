# tty with modern font rendering
# https://github.com/Aetf/kmscon
{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
    theme = cfg.style.catppuccin;
in
{
    options.sidonia.services.kmscon.enable =
        lib.mkEnableOption "Enable kmscon as a richer tty replacement";
    config =
        let
            configDir = pkgs.writeTextFile {
                name = "kmscon-config";
                destination = "/kmscon.conf";
                text =
                    let
                        rgb = lib.mapAttrs (n: v: v.rgb) theme.color;
                    in
                    with rgb;
                    ''
                        xkb-layout=${cfg.input.keyLayout}

                        font-size=14

                        palette=custom
                        palette-foreground=${text}
                        palette-background=${base}

                        palette-black=${surface1}
                        palette-red=${red}
                        palette-green=${green}
                        palette-yellow=${peach}
                        palette-blue=${blue}
                        palette-magenta=${pink}
                        palette-cyan=${lavender}
                        palette-light-grey=${subtext1}

                        palette-dark-grey=${surface2}
                        palette-light-red=${maroon}
                        palette-light-green=${teal}
                        palette-light-yellow=${yellow}
                        palette-light-blue=${sky}
                        palette-light-magenta=${flamingo}
                        palette-light-cyan=${sapphire}
                        palette-white=${text}

                        ${lib.optionalString config.hardware.graphics.enable ''
                            drm
                            hwaccel
                        ''}
                        ${lib.optionalString config.fonts.fontconfig.enable ''
                            font-name=${lib.strings.concatStringsSep ", " config.fonts.fontconfig.defaultFonts.monospace}
                        ''}
                    '';
            };
        in
        lib.mkIf cfg.services.kmscon.enable {
            # ensure services.kmscon does not screw with kmsconvt@.service
            #disabledModules = ["services/ttys/kmscon.nix"];
            services.kmscon.enable = lib.mkForce false;

            # add all systemd overrides from services/ttys/kmscon.nix aside from ExecStart as we have it patched in the package overlay
            systemd = {
                packages = [ pkgs.kmscon ];
                services = {
                    systemd-vconsole-setup.enable = false;
                    reload-systemd-vconsole-setup.enable = false;
                    "kmsconvt@" = {
                        after = [
                            "systemd-logind.service"
                            "systemd-vconsole-setup.service"
                        ];
                        requires = [ "systemd-logind.service" ];
                        restartIfChanged = false;
                        aliases = [ "autovt@.service" ];
                    };
                };
                suppressedSystemUnits = [ "autovt@.service" ];
            };

            nixpkgs.overlays = [
                (final: prev: {
                    kmscon = (
                        prev.kmscon.overrideAttrs {
                            src = cfg.src.kmscon;
                            buildInputs = with pkgs; [
                                util-linux
                                check
                                libGLU
                                libGL
                                libdrm
                                libgbm
                                (libtsm.overrideAttrs {
                                    # https://github.com/Aetf/kmscon/issues/64
                                    src = cfg.src.libtsm;
                                    nativeBuildInputs = [
                                        meson
                                        cmake
                                        check
                                        ninja
                                        pkg-config
                                    ];
                                })
                                libxkbcommon
                                pango
                                pixman
                                systemd
                                mesa
                            ];

                            env.NIX_CFLAGS_COMPILE =
                                lib.optionalString pkgs.stdenv.cc.isGNU "-O" # _FORTIFY_SOURCE requires compiling with optimization (-O)
                                + " -Wno-error=maybe-uninitialized" # https://github.com/Aetf/kmscon/issues/49
                                + " -Wno-error=implicit-function-declaration"; # https://github.com/Aetf/kmscon/issues/64

                            patches = [
                                # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/km/kmscon/sandbox.patch
                                (pkgs.writeText "sandbox.patch" ''
                                    From d51e35a7ab936983b2a544992adae66093c6028f Mon Sep 17 00:00:00 2001
                                    From: hustlerone <nine-ball@tutanota.com>
                                    Date: Thu, 20 Feb 2025 11:05:56 +0100
                                    Subject: [PATCH] Patch for nixpkgs
                                    
                                    ---
                                     meson.build | 2 +-
                                     1 file changed, 1 insertion(+), 1 deletion(-)
                                    
                                    diff --git a/meson.build b/meson.build
                                    index 964b44b..4415084 100644
                                    --- a/meson.build
                                    +++ b/meson.build
                                    @@ -39,7 +39,7 @@ mandir = get_option('mandir')
                                     moduledir = get_option('libdir') / meson.project_name()
                                     
                                     systemd_deps = dependency('systemd', required: false)
                                    -systemdsystemunitdir = systemd_deps.get_variable('systemdsystemunitdir', default_value: 'lib/systemd/system')
                                    +systemdsystemunitdir = 'lib/systemd'
                                     
                                     #
                                     # Required dependencies
                                    -- 
                                    2.47.2
                                '')
                                # Fix agetty binary paths and link the configuration directory
                                (pkgs.writeText "kmscon.service.in.patch" ''
                                    diff --git a/docs/kmscon.service.in b/docs/kmscon.service.in
                                    index ad5600d..664bbfb 100644
                                    --- a/docs/kmscon.service.in
                                    +++ b/docs/kmscon.service.in
                                    @@ -6,7 +6,7 @@ After=systemd-user-sessions.service
                                     After=rc-local.service
                                     
                                     [Service]
                                    -ExecStart=@bindir@/kmscon --login -- /sbin/agetty -o '-p -- \\u' --noclear -- -
                                    +ExecStart=@bindir@/kmscon --configdir ${configDir} --login -- ${pkgs.util-linux}/bin/agetty -o '-p -- \\u' --noclear -- -
                                     
                                     [Install]
                                     WantedBy=multi-user.target
                                '')
                                (pkgs.writeText "kmsconvt@.service.in.patch" ''
                                    diff --git a/docs/kmsconvt@.service.in b/docs/kmsconvt@.service.in
                                    index a496e26..18a1f93 100644
                                    --- a/docs/kmsconvt@.service.in
                                    +++ b/docs/kmsconvt@.service.in
                                    @@ -38,7 +38,7 @@ IgnoreOnIsolate=yes
                                     ConditionPathExists=/dev/tty0
                                     
                                     [Service]
                                    -ExecStart=@bindir@/kmscon --vt=%I --seats=seat0 --no-switchvt --login -- /sbin/agetty -o '-p -- \\u' --noclear -- -
                                    +ExecStart=@bindir@/kmscon --vt=%I --seats=seat0 --no-switchvt --configdir ${configDir} --login -- ${pkgs.util-linux}/bin/agetty -o '-p -- \\u' --noclear -- -
                                     UtmpIdentifier=%I
                                     TTYPath=/dev/%I
                                     TTYReset=yes
                                '')
                            ];
                        }
                    );
                })
            ];
        };
}
