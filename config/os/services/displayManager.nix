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
    config = lib.mkIf cfg.desktop.enable (
        lib.mkMerge [
            {
                services.displayManager = {
                    autoLogin.enable = lib.mkDefault false;
                    autoLogin.user = lib.mkDefault cfg.userName;
                    cosmic-greeter.enable = lib.mkDefault true;
                };
            }
            (lib.mkIf (cfg.desktop.compositor == "niri") {
                services.displayManager.defaultSession = lib.mkDefault "niri";
            })
        ]
    );
}
