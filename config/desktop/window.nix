{
    config,
    lib,
    pkgs,
    ...
}:
let
    cfg = config.sidonia;
in
{
    options.sidonia.desktop.window = {
        decoration = {
            rounding = lib.mkOption {
                description = "Window rounding";
                type = lib.types.int;
                default = 10;
            };
            borderWidth = lib.mkOption {
                description = "Border width";
                type = lib.types.int;
                default = 2;
            };
            opacity = lib.mkOption {
                description = "Decimal opacity value for floating window transparency.";
                type = lib.types.float;
                default = 0.8;
                apply = dec: {
                    inherit dec;
                    hex = lib.toHexString (builtins.floor (dec * 255));
                };
            };
            float = lib.mkOption {
                description = "Legacy floating window configuration";
                default = { };
                type = lib.types.submodule {
                    options = {
                        w = lib.mkOption {
                            description = "Default floating window width";
                            type = lib.types.int;
                            default = 896;
                        };
                        h = lib.mkOption {
                            description = "Default floating window height";
                            type = lib.types.int;
                            default = 504;
                        };
                    };
                };
                apply = x: {
                    inherit (x) w h;
                    wh = (builtins.toString x.w) + " " + (builtins.toString x.h);
                    onCursor = "move onscreen cursor -50% -50%";
                };
            };
        };
    };
}
