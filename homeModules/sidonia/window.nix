{
    osConfig,
    config,
    lib,
    pkgs,
    ...
}:
{
    options.wayland.desktopManager.sidonia.window = {
        decoration = {
            rounding = lib.mkOption {
                description = "Window rounding";
                type = lib.types.int;
                default = 10;
            };
            borderWidth = lib.mkOption {
                description = "Border width";
                type = lib.types.int;
                default = 4;
            };
            opacity = lib.mkOption {
                description = "Decimal opacity value for floating window transparency.";
                type = lib.types.float;
                default = if osConfig.sidonia.graphics.legacyGpu then 1. else 0.98;
                apply = dec: {
                    inherit dec;
                    hex = lib.toHexString (builtins.floor (dec * 255));
                };
            };
        };
    };
}
