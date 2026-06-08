{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
{
  options.catppuccin.niri.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.catppuccin.enable;
  };
  config = lib.mkIf (config.wayland.windowManager.niri.enable && config.catppuccin.niri.enable) {
    wayland.windowManager.niri.settings =
      let
        rgb = lib.mapAttrs (n: v: "#${v}") config.catppuccin.lib.color;
        colors = {
          active-color = lib.mkDefault rgb.accent;
          inactive-color = lib.mkDefault rgb.overlay2;
          urgent-color = lib.mkDefault rgb.yellow;
        };
      in
      {
        layout = {
          background-color = lib.mkDefault rgb.crust;
          focus-ring = colors;
          border = colors;
          tab-indicator = colors;
          insert-hint.color = lib.mkDefault "${rgb.accent}80";
        };
        cursor = {
          xcursor-theme = with config.catppuccin.cursors; "catppuccin-${flavor}-${accent}-cursors";
        };
      };
  };
}
