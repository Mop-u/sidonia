{
    inputs,
}:
{
    config,
    lib,
    pkgs,
    std,
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
                            theme = (import ./lib/catppuccin.nix).${x.flavor};
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
            };
        };
    };

    imports = with inputs; [
        catppuccin.nixosModules.catppuccin
        home-manager.nixosModules.home-manager
        aagl.nixosModules.default
        ./config
    ];

    config =
        let
            overlays = (import ./overlays.nix) { inherit inputs lib; };
        in
        lib.mkMerge [
            {
                home-manager = {
                    extraSpecialArgs = { inherit std; };
                    backupFileExtension = "backup";
                    sharedModules = [
                        inputs.catppuccin.homeModules.catppuccin
                        inputs.niri.homeModules.niri
                        inputs.hyprshell.homeModules.hyprshell
                        {
                            config.nixpkgs = {
                                inherit overlays;
                                config.allowUnfree = true;
                            };
                            options.catppuccin.lib.color = lib.mkOption {
                                readOnly = true;
                                type = lib.types.attrsOf lib.types.str;
                                default = cfg.style.catppuccin.color;
                            };
                        }
                        ./homeModules
                    ];
                    users.${cfg.userName} = {
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
                nixpkgs = { inherit overlays; };
            }
        ];
}
