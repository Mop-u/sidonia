{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
in
{
    options.sidonia.programs.vesktop.enable =
        with lib;
        mkOption {
            description = "Enable Vesktop, A custom Discord App aiming to give you better performance and improve linux support";
            type = types.bool;
            default = cfg.desktop.enable;
        };
    config.home-manager.users.${cfg.userName}.programs.vesktop.enable = lib.mkDefault cfg.desktop.enable;
}
