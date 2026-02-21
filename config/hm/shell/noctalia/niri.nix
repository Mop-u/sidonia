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
lib.mkIf
    (cfg.desktop.enable && (cfg.desktop.compositor == "niri") && (cfg.desktop.shell == "noctalia"))
    {
        # https://docs.noctalia.dev/getting-started/compositor-settings/niri/


    }
