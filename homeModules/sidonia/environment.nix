{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.wayland.desktopManager.sidonia;
  mapListToAttrs =
    f: list:
    builtins.listToAttrs (
      map (name: {
        inherit name;
        value = f name;
      }) list
    );
in
{
  options.wayland.desktopManager.sidonia.environment = lib.mkOption {
    description = "Environment variables initialized by the compositor.";
    type = with lib.types; attrsOf (nullOr (coercedTo int toString str));
    default = { };
    apply = x: lib.filterAttrs (n: v: v != null) x;
  };
}
