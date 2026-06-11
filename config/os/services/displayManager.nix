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
  config = lib.mkIf cfg.desktop.enable {
    services.displayManager = {
      autoLogin.enable = lib.mkDefault false;
      autoLogin.user = lib.mkDefault cfg.userName;
    };
    programs.noctalia-greeter.enable = lib.mkDefault true;
  };
}
