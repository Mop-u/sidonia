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
        description = "Decimal value for inactive window opacity.";
        type = lib.types.float;
        default = 0.965;
        apply = dec: {
          inherit dec;
          hex = lib.toHexString (builtins.floor (dec * 255));
        };
      };
    };
  };
}
