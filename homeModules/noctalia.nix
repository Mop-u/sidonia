{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
let
    tomlFormat = pkgs.formats.toml { };
in
{
    options = {
        programs.noctalia = {
            enable = lib.mkEnableOption "Enable noctalia shell";
            package = lib.mkOption {
                type = lib.types.package;
                default = pkgs.noctalia;
            };
            settings = lib.mkOption {
                 type = lib.types.nullOr tomlFormat.type;
                 default = null; 
            };
        };
        catppuccin.noctalia.enable = lib.mkOption {
            type = lib.types.bool;
            default = config.catppuccin.enable;
        };
    };
    config = lib.mkIf config.programs.noctalia.enable {
        home.packages = [ config.programs.noctalia.package ]; 
        xdg.configFile."noctalia/config.toml".source = lib.mkIf (config.programs.noctalia.settings != null) (
            tomlFormat.generate "config.toml" config.programs.noctalia.settings
        );
        programs.noctalia.settings = lib.mkIf config.catppuccin.noctalia.enable {
            theme = {
                mode = "auto";
                source = "builtin";
                builtin = "Catppuccin";
            };
        };
    };
}
