{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
lib.mkIf (config.wayland.windowManager.hyprland.enable && config.catppuccin.hyprland.enable)
    {
        wayland.windowManager.hyprland.settings =
            let
                color = config.catppuccin.lib.color // {
                    shadow = "000000";
                };
                rgb = lib.mapAttrs (n: v: "rgb(${v})") color;
                rgba = lib.mapAttrs (n: v: (alpha: "rgba(${v}${alpha})")) color;
            in
            {
                # Gradients:
                general."col.active_border" = rgb.accent; # border color for the active window
                general."col.inactive_border" = rgb.overlay2; # border color for inactive windows
                general."col.nogroup_border_active" = rgb.maroon; # active border color for window that cannot be added to a group (see denywindowfromgroup dispatcher)
                general."col.nogroup_border" = rgb.overlay2; # inactive border color for window that cannot be added to a group (see denywindowfromgroup dispatcher)

                group."col.border_active" = rgb.flamingo; # active group border color
                group."col.border_inactive" = rgb.overlay2; # inactive (out of focus) group border color
                group."col.border_locked_active" = "${rgb.flamingo} ${rgb.accent} 45deg"; # active locked group border color
                group."col.border_locked_inactive" = rgb.overlay2; # inactive locked group border color

                group.groupbar."col.active" = rgb.flamingo; # active group border color
                group.groupbar."col.inactive" = rgb.overlay2; # inactive (out of focus) group border color
                group.groupbar."col.locked_active" = "${rgb.flamingo} ${rgb.accent} 45deg"; # active locked group border color
                group.groupbar."col.locked_inactive" = rgb.overlay2; # inactive locked group border color

                # Colours:
                group.groupbar.text_color = rgb.text; # controls the group bar text color
                misc."col.splash" = rgb.text; # Changes the color of the splash text (requires a monitor reload to take effect).
                misc.background_color = rgb.crust; # change the background color. (requires enabled disable_hyprland_logo)

                windowrule = [
                    "match:xwayland 1, match:focus 0, border_color ${rgb.overlay2}"
                    "match:xwayland 1, match:focus 1, border_color ${rgb.yellow}"
                ];
            };
    }
