{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
in
lib.mkIf (cfg.desktop.enable && (cfg.desktop.shell == "legacy")) {
    catppuccin.dunst.enable = false; # using our own values as overriding background breaks opacity
    services.dunst = {
        enable = true;
        settings =
            let
                rounding = builtins.toString cfg.desktop.window.decoration.rounding;
                borderSize = builtins.toString cfg.desktop.window.decoration.borderWidth;
                opacity = cfg.desktop.window.decoration.opacity.hex;
                palette = builtins.mapAttrs (n: v: "#${v}") config.catppuccin.lib.color;
            in
            with palette;
            {
                # https://dunst-project.org/documentation/
                global = {
                    width = 400;
                    font = "Monospace 12";
                    line_height = 4;
                    padding = 12;
                    horizontal_padding = 12;
                    follow = "mouse";
                    origin = "bottom-center";
                    enable_recursive_icon_lookup = true;
                    dmenu = "${pkgs.bemenu}/bin/bemenu -p dunst";
                    layer = "overlay";
                    frame_width = borderSize;
                    corner_radius = rounding;
                    highlight = accent;
                    separator_color = accent;
                };
                urgency_low = {
                    background = base + opacity;
                    foreground = text;
                    frame_color = accent;
                };
                urgency_normal = {
                    background = base + opacity;
                    foreground = text;
                    frame_color = accent;
                };
                urgency_high = {
                    background = base + opacity;
                    foreground = text;
                    frame_color = red;
                };
            };
    };
}
