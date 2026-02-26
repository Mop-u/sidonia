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
        # environment.sidonia.excludePackages
        # environment.sidonia.sessionVariables.{hyprland/niri}
        # services.desktopManager.sidonia.enable
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
            geolocation.enable = mkEnableOption "Turn on geolocation related services such as automatic timezone changing and geoclue";
            isLaptop = mkEnableOption "Apply laptop-specific tweaks";
            graphics.legacyGpu = mkEnableOption "Apply tweaks for OpenGL ES 2 device support";
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
                            if (builtins.isNull x.source) then
                                pkgs.comic-code
                            else
                                (pkgs.comic-code.overrideAttrs { src = x.source; });
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
                shell = mkOption {
                    description = "What desktop shell to use";
                    type = types.enum [
                        "noctalia"
                    ];
                    default = "noctalia";
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
                    backupFileExtension = "backup";
                    sharedModules = [
                        inputs.catppuccin.homeModules.catppuccin
                        inputs.niri.homeModules.niri
                        inputs.noctalia.homeModules.default
                        {
                            config.nixpkgs = {
                                inherit overlays;
                                config.allowUnfree = true;
                            };
                            options.catppuccin.lib.color = lib.mkOption {
                                readOnly = true;
                                type = lib.types.attrsOf lib.types.str;
                                default =
                                    let
                                        theme = (import ./lib/catppuccin.nix).${config.catppuccin.flavor};
                                    in
                                    theme
                                    // {
                                        accent = theme.${config.catppuccin.accent};
                                    };
                            };
                        }
                        ./homeModules
                    ];
                    users.${cfg.userName} = {
                        home = {
                            username = config.sidonia.userName;
                            homeDirectory = "/home/${config.sidonia.userName}";
                            stateVersion = lib.mkDefault config.system.stateVersion;
                        };
                        catppuccin = {
                            inherit (config.catppuccin) enable accent flavor;
                        };
                    };
                };
                nixpkgs = { inherit overlays; };
            }
        ];
}
