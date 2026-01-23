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
            default = cfg.graphics.enable;
        };
    config = lib.mkIf (cfg.programs.vesktop.enable) {
        home-manager.users.${cfg.userName} = {
            home.packages = [
                pkgs.vesktop
            ];
        };
    };
}
