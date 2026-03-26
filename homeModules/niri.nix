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
    config = lib.mkIf (config.programs.niri.enable && config.catppuccin.niri.enable) {
        programs.niri.settings.layout =
            let
                rgb = lib.mapAttrs (n: v: "#${v}") config.catppuccin.lib.color;
                colors = {
                    active.color = lib.mkDefault rgb.accent;
                    inactive.color = lib.mkDefault rgb.overlay2;
                    urgent.color = lib.mkDefault rgb.yellow;
                };
            in
            {
                background-color = lib.mkDefault rgb.crust;
                focus-ring = colors;
                border = colors;
                tab-indicator = colors;
                insert-hint.display.color = lib.mkDefault "${rgb.accent}80";
                #shadow = lib.mapAttrs (n: v: lib.mkDefault v) {
                #    color = "";
                #    inactive-color = "";
                #};
            };
    };
}
