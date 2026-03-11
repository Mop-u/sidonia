{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
in
lib.mkIf (cfg.desktop.enable && (cfg.desktop.compositor == "hyprland")) {
    programs.hyprland = {
        enable = true;
        withUWSM = true;
    };
    # see: https://wiki.hypr.land/Nix/Hyprland-on-NixOS/
    # see: https://github.com/hyprwm/Hyprland/issues/5148
    hardware.graphics = {
        package = pkgs.hyprland-mesa;
        package32 = pkgs.hyprland-mesa32;
    };
}
