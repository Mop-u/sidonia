{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.catppuccin.helix;
  subdir = if cfg.useItalics then "default" else "no_italics";
  inherit (config.catppuccin) sources;
  tomlFormat = pkgs.formats.toml { };
in
{
  options.catppuccin.helix.useTransparency = lib.mkOption {
    type = lib.types.bool;
    default = true;
  };
  config = lib.mkMerge [
    {
      catppuccin.helix = {
        enable = lib.mkDefault false; # Override default theme so we can apply transparency
        useItalics = lib.mkDefault true;
      };
    }
    (lib.mkIf config.catppuccin.enable {
      programs.helix.settings = {
        theme = "catppuccin-${cfg.flavor}-transparent";
        editor = {
          color-modes = lib.mkDefault true;
          rainbow-brackets = lib.mkDefault true;
        };
      };
      xdg.configFile = {
        "helix/themes/catppuccin-${cfg.flavor}.toml".source =
          "${sources.helix}/${subdir}/catppuccin_${cfg.flavor}.toml";
        "helix/themes/catppuccin-${cfg.flavor}-transparent.toml".source =
          tomlFormat.generate "catppuccin-transparent.toml"
            {
              inherits = "catppuccin-${cfg.flavor}";
              "ui.background" = { };
            };
      };
    })
  ];
}
