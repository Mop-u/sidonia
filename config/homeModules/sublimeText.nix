{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
    capitalize =
        str:
        let
            chars = lib.stringToCharacters str;
        in
        lib.concatStrings ([ (lib.toUpper (builtins.head chars)) ] ++ (builtins.tail chars));
    catppuccinBaseName = "Catppuccin ${capitalize config.catppuccin.flavor}";
    catppuccinColorScheme = "${catppuccinBaseName}.sublime-color-scheme";

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
    config = lib.mkIf config.programs.sublime4.enable {
        home.packages = [ pkgs.sublime4 ];
        xdg.configFile =
            let
                stextPackages = mapDirs "sublime-text/Packages" config.programs.sublime4.packages;
                stextSettings = mapFiles "sublime-text/Packages/User" (
                    config.programs.sublime4.userFile
                    // (
                        if config.programs.sublime4.settings != null then
                            { "Preferences.sublime-settings".text = builtins.toJSON config.programs.sublime4.settings; }
                        else
                            { }
                    )
                );
            in
            (stextPackages // stextSettings);
        programs.sublime4 = lib.mkIf config.catppuccin.sublime4.enable {
            settings = {
                color_scheme = catppuccinColorScheme;
            };
            packages = {
                inherit (pkgs.sublimePackages) "Catppuccin color schemes";
            };
        };
    };
}
