{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
in
lib.mkIf (cfg.desktop.enable) {
    security.pam.services = (
        if cfg.graphics.legacyGpu then
            { swaylock.enableGnomeKeyring = true; }
        else
            { hyprlock.enableGnomeKeyring = true; }
    );
}
