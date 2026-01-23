{
    config,
    pkgs,
    lib,
    std,
    ...
}:
let
    cfg = config.sidonia;
    theme = cfg.style.catppuccin;
    surferTheme =
        with lib.mapAttrs (n: v: v.hex) theme.color;
        std.serde.toTOML {
            foreground = text;
            alt_text_color = surface0; # negated foreground
            border_color = surface0;
            selected_elements_colors = {
                background = surface1;
                foreground = text;
            };
            canvas_colors = {
                background = crust;
                alt_background = base;
                foreground = text;
            };
            primary_ui_color = {
                background = mantle;
                foreground = text;
            };
            secondary_ui_color = {
                background = crust;
                foreground = text;
            };
            accent_info = {
                background = blue;
                foreground = text;
            };
            accent_warn = {
                background = surface0;
                foreground = text;
            };
            accent_error = {
                background = red;
                foreground = text;
            };
            clock_highlight_line = {
                color = overlay0;
                width = 2;
            };
            clock_highlight_cycle = base;
            clock_rising_marker = false;
            variable_default = green;
            variable_undef = red;
            variable_highimp = yellow;
            variable_dontcare = blue;
            variable_weak = overlay1;
            variable_parameter = text;
            transaction_default = green;
            waveform_opacity = 0.2;
            wide_opacity = 0.0;
            cursor = {
                color = accent;
                width = 2;
            };
            gesture = {
                color = yellow;
                width = 2;
            };
            measure = {
                color = overlay1;
                width = 2;
            };
            linewidth = 2;
            vector_transition_width = 6;
            alt_frequency = 3;
            viewport_separator = {
                color = text;
                width = 4;
            };
            drag_threshold = 1.0;
            drag_hint_color = subtext1;
            drag_hint_width = 2.0;
            highlight_background = surface1;

            colors = {
                Green = green;
                Red = red;
                Yellow = yellow;
                Blue = blue;
                Pink = mauve;
                Orange = peach;
                Gray = overlay1;
                Violet = lavender;
            };

            ticks = {
                style = {
                    color = base;
                    width = 2;
                };
                density = 1;
            };

            relation_arrow = {
                style = {
                    color = red;
                    width = 1.3;
                };
                head_angle = 25;
                head_length = 8;
            };
        };
in
{
    options.sidonia.programs.surfer.enable = lib.mkEnableOption "Enable surfer waveform viewer";
    config = lib.mkIf cfg.programs.surfer.enable {
        home-manager.users.${cfg.userName} = {
            home.packages = with pkgs; [
                surfer
            ];
            xdg.configFile."surfer/themes/catppuccin.toml".text = surferTheme;
        };
    };
}
