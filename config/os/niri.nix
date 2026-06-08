{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.sidonia;
in
lib.mkIf (cfg.desktop.enable && (cfg.desktop.compositor == "niri")) {
  programs.niri = {
    enable = true;
    package = lib.mkDefault pkgs.niri-unstable;
    useNautilus = lib.mkDefault false;
    withUWSM = lib.mkDefault true;
    withXDG = lib.mkDefault true;
  };
}
