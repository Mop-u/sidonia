{
    inputs,
}:
{
    config,
    lib,
    pkgs,
    otherHosts,
    ...
}:
let
    cfg = config.sidonia;
    fromHexString = hex: (builtins.fromTOML "getInt = 0h${hex}").getInt;
in
{
    options = with lib; {
        sidonia = {
            src = mkOption {
                readOnly = true;
                type = types.attrs;
                default = {
                    inherit (inputs)
                        nix-vscode-extensions
                        stextCatppuccin
                        stextPackageControl
                        stextLSP
                        stextNix
                        stextSystemVerilog
                        stextHooks
                        ;
                };
            };
            lib = mkOption {
                readOnly = true;
                type = types.attrs;
                default = {
                    capitalize =
                        str:
                        let
                            chars = stringToCharacters str;
                        in
                        concatStrings ([ (toUpper (builtins.head chars)) ] ++ (builtins.tail chars));
                    fromHexToRgb =
                        hex:
                        concatStringsSep ", " (
                            builtins.map (x: toString (fromHexString x)) [
                                (builtins.substring 0 2 hex)
                                (builtins.substring 2 2 hex)
                                (builtins.substring 4 2 hex)
                            ]
                        );

                    isInstalled =
                        package:
                        builtins.elem package.pname (
                            builtins.catAttrs "pname" (
                                config.environment.systemPackages
                                ++ config.users.users.${cfg.userName}.packages
                                ++ config.home-manager.users.${cfg.userName}.home.packages
                            )
                        );

                    home = {
                        applications = "/home/${cfg.userName}/.nix-profile/share/applications";
                        autostart = "/home/${cfg.userName}/.config/autostart";
                    };
                    configContainerCredential =
                        f: service: path:
                        let
                            rootCredName = "${service}CredentialRoot";
                            localCredName = "${service}CredentialLocal";
                        in
                        {
                            extraFlags = [ "--load-credential=${rootCredName}:${path}" ];
                            config = lib.mkMerge [
                                { systemd.services."${service}".serviceConfig.LoadCredential = "${localCredName}:${rootCredName}"; }
                                (f "/run/credentials/${service}.service/${localCredName}")
                            ];
                        };
                };
            };
            ssh = {
                pubKey = lib.mkOption {
                    type = types.str;
                    default = "";
                };
                privKeyPath = lib.mkOption {
                    type = types.path;
                    default = "/home/${cfg.userName}/.ssh/id_ed25519";
                };
            };
            userName = mkOption {
                description = "Username of main user";
                type = types.str;
            };
            stateVer = mkOption {
                description = "NixOS state version";
                type = types.str;
            };
            system = mkOption {
                description = "System architecture";
                type = types.enum [
                    "x86_64-linux"
                    "x86_64-darwin"
                    "i686-linux"
                    "aarch64-linux"
                    "aarch64-darwin"
                    "armv6l-linux"
                    "armv7l-linux"
                ];
                default = "x86_64-linux";
            };
            geolocation.enable = mkEnableOption "Turn on geolocation related services such as automatic timezone changing and geoclue";
            isLaptop = mkEnableOption "Apply laptop-specific tweaks";
            graphics.legacyGpu = mkEnableOption "Apply tweaks for OpenGL ES 2 device support";
            style = {
                # use `apply` attribute in mkOption to convert input options & avoid hacking nixpkgs lib
                catppuccin = mkOption {
                    description = "Catppuccin configuration";
                    default = { };
                    type = types.submodule {
                        options = {
                            flavor = mkOption {
                                description = "Catppuccin theme flavor";
                                type = types.enum [
                                    "latte"
                                    "frappe"
                                    "macchiato"
                                    "mocha"
                                ];
                                default = "frappe";
                            };
                            accent = mkOption {
                                description = "Catppuccin theme accent";
                                type = types.enum [
                                    "rosewater"
                                    "flamingo"
                                    "pink"
                                    "mauve"
                                    "red"
                                    "maroon"
                                    "peach"
                                    "yellow"
                                    "green"
                                    "teal"
                                    "sky"
                                    "sapphire"
                                    "blue"
                                    "lavender"
                                ];
                                default = "mauve";
                            };
                        };
                    };
                    apply =
                        x:
                        let
                            theme = (import ./lib/catppuccin.nix).catppuccin.${x.flavor};
                        in
                        {
                            inherit (x) flavor accent;
                            color = theme // {
                                accent = theme.${x.accent};
                            };
                        };
                };
                cursorSize = mkOption {
                    description = "Cursor size";
                    type = types.int;
                    default = 30;
                };
            };

            text = {
                comicCode = mkOption {
                    default = { };
                    type = types.submodule {
                        options = {
                            enable = mkEnableOption "Use Comic Code monospace font";
                            source = mkOption {
                                description = "Source zip file containing the font";
                                type = types.nullOr types.path;
                                default = null;
                            };
                        };
                    };
                    apply = x: {
                        inherit (x) enable;
                        package =
                            let
                                comicCode = inputs.nonfree-fonts.packages.${cfg.system}.comic-code;
                            in
                            if (x.source == null) then comicCode else (comicCode.overrideAttrs { src = x.source; });
                        name = if x.enable then "Comic Code" else "ComicShannsMono Nerd Font";
                    };
                };
            };
            input = {
                sensitivity = mkOption {
                    description = "Mouse sensitivity range from -1.0 to 1.0";
                    type = types.float;
                    default = 0.0;
                };
                accelProfile = mkOption {
                    description = "Hyprland mouse acceleration profile";
                    type = types.enum [
                        "adaptive"
                        "flat"
                        "custom"
                    ];
                    default = "flat";
                };
                keyLayout = mkOption {
                    description = "Keyboard layout";
                    type = types.str;
                    default = "us";
                };
            };
            desktop = {
                enable = mkEnableOption "Enable desktop environment";
                compositor = mkOption {
                    description = "Which compositor to use";
                    type = types.enum [
                        "hyprland"
                        "niri"
                    ];
                    default = "hyprland";
                };
                monitors = mkOption {
                    description = "List of monitor configurations ( see https://wiki.hyprland.org/Configuring/Monitors/ )";
                    type =
                        with types;
                        listOf (submodule {
                            options = {
                                name = mkOption {
                                    description = "Name of monitor";
                                    type = types.str;
                                };
                                resolution = mkOption {
                                    description = "Resolution in the format WIDTHxHEIGHT. Default is highest available resolution.";
                                    type = types.str;
                                    default = "highres";
                                };
                                position = mkOption {
                                    description = "Monitor position in scaled pixels WIDTHxHEIGHT";
                                    type = types.str;
                                    default = "auto";
                                };
                                refresh = mkOption {
                                    description = "Monitor refresh rate";
                                    type = types.nullOr types.float;
                                    default = null;
                                };
                                scale = mkOption {
                                    description = "Monitor scale factor";
                                    type = types.nullOr types.float;
                                    default = null;
                                };
                                bitdepth = mkOption {
                                    description = "Monitor bit depth";
                                    type = types.nullOr (
                                        types.enum [
                                            8
                                            10
                                        ]
                                    );
                                    default = null;
                                };
                                hdr = mkEnableOption "Enable HDR for this monitor";
                                extraArgs = mkOption {
                                    description = "Extra comma-separated monitor properties";
                                    type = types.nullOr types.str;
                                    default = null;
                                };
                            };
                        });
                    default = [ ];
                };
            };
        };
    };

    imports = with inputs; [
        catppuccin.nixosModules.catppuccin
        home-manager.nixosModules.home-manager
        aagl.nixosModules.default
        ./config
    ];

    config = lib.mkMerge [
        {
            home-manager = {
                useGlobalPkgs = true;
                backupFileExtension = "backup";
                users.${cfg.userName} = {
                    imports = with inputs; [
                        catppuccin.homeModules.catppuccin
                        niri.homeModules.niri
                        hyprshell.homeModules.hyprshell
                    ];
                    home = {
                        username = config.sidonia.userName;
                        homeDirectory = "/home/${config.sidonia.userName}";
                        stateVersion = config.sidonia.stateVer;
                    };
                    catppuccin = {
                        enable = true;
                        accent = config.sidonia.style.catppuccin.accent;
                        flavor = config.sidonia.style.catppuccin.flavor;
                    };
                };
            };
            nixpkgs.overlays =
                let
                    getSystem = overlayPkgs: overlayPkgs.stdenv.hostPlatform.system;
                    overlayMissingFromFlake =
                        flake:
                        (
                            final: prev:
                            if builtins.hasAttr (getSystem prev) flake.packages then
                                lib.filterAttrs (n: v: !(builtins.hasAttr n prev)) flake.packages.${getSystem prev}
                            else
                                { }
                        );
                in
                [
                    (final: prev: {
                        inherit (inputs.unstable.legacyPackages.${getSystem prev}) magnetic-catppuccin-gtk surfer;
                    })
                    (final: prev: {
                        affinity = inputs.affinity.packages.${getSystem prev}.v3;
                        nix-auth = inputs.nix-auth.packages.${getSystem prev}.default;
                        inherit (inputs.hyprland.packages.${getSystem prev}) hyprland xdg-desktop-portal-hyprland;
                        inherit (inputs.hyprshell.packages.${getSystem prev}) hyprshell-nixpkgs hyprshell;
                    })
                    (overlayMissingFromFlake inputs.nixpkgs-xr) # use nixpkgs stable where possible
                    inputs.nur.overlays.default
                    inputs.niri.overlays.niri
                ];
        }
    ];
}
