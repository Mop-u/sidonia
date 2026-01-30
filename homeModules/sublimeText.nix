{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.programs.sublime4;
    capitalize =
        str:
        let
            chars = lib.stringToCharacters str;
        in
        lib.concatStrings ([ (lib.toUpper (builtins.head chars)) ] ++ (builtins.tail chars));

    remapAttrs = f: attrset: builtins.listToAttrs (builtins.map (f) (lib.attrsToList attrset));

    mapDirs =
        path:
        (remapAttrs (attr: {
            name = "${path}/${attr.name}";
            value.source = attr.value;
        }));
    mapFiles =
        path:
        (remapAttrs (attr: {
            name = "${path}/${attr.name}";
            inherit (attr) value;
        }));
in
{
    options = {
        programs.sublime4 = {
            enable = lib.mkEnableOption "Enable sublime text 4";
            settings = lib.mkOption {
                type = lib.types.nullOr lib.types.attrs;
                default = null;
            };
            userFile = lib.mkOption {
                type = lib.types.attrs;
                default = { };
            };
            packageControl = {
                enable = lib.mkEnableOption "Enable declarative package control configuration";
                packages = lib.mkOption {
                    type = lib.types.nullOr (lib.types.listOf lib.types.str);
                    default = null;
                };
                extraSettings = lib.mkOption {
                    type = lib.types.nullOr lib.types.attrs;
                    default = null;
                };
            };
            packages = lib.mkOption {
                type = lib.types.attrsOf lib.types.path;
                default = { };
            };
        };

        catppuccin.sublime4.enable = lib.mkOption {
            type = lib.types.bool;
            default = config.catppuccin.enable;
        };
    };
    config = lib.mkIf cfg.enable {
        home.packages = [ pkgs.sublime4 ];
        xdg.configFile =
            let
                stextPackages = mapDirs "sublime-text/Packages" cfg.packages;
                stextSettings = mapFiles "sublime-text/Packages/User" (
                    cfg.userFile
                    // (
                        if cfg.settings != null then
                            { "Preferences.sublime-settings".text = builtins.toJSON cfg.settings; }
                        else
                            { }
                    )
                    // (
                        if (cfg.packageControl.enable) && (cfg.packageControl.extraSettings != null) then
                            { "Package Control.sublime-settings".text = builtins.toJSON cfg.packageControl.extraSettings; }
                        else
                            { }
                    )
                );
            in
            (stextPackages // stextSettings);
        programs.sublime4 = lib.mkMerge [
            (lib.mkIf cfg.packageControl.enable {
                packages = { inherit (pkgs.sublimePackages) "Package Control"; };
            })
            (lib.mkIf (cfg.packageControl.enable && (cfg.packageControl.packages != null)) {
                packageControl.extraSettings.installed_packages = cfg.packageControl.packages;
            })
            (lib.mkIf config.catppuccin.sublime4.enable {
                settings = {
                    color_scheme = "Catppuccin ${capitalize config.catppuccin.flavor}.sublime-color-scheme";
                    theme = "Adaptive.sublime-theme";
                };
                packages = {
                    inherit (pkgs.sublimePackages) "Catppuccin color schemes";
                };
            })
        ];
    };
}
