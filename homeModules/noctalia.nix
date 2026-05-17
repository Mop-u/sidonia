{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
{
    options.catppuccin.noctalia.enable = lib.mkOption {
        type = lib.types.bool;
        default = config.catppuccin.enable;
    };
    config = lib.mkIf config.programs.noctalia.enable {
        programs.noctalia.settings = lib.mkIf config.catppuccin.noctalia.enable {
            theme = {
                mode = "auto";
                source = "builtin";
                builtin = "Catppuccin";
            };
        };
    };
}
