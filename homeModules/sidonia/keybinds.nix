{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.wayland.desktopManager.sidonia;
  capitalize =
    x:
    let
      chars = lib.stringToCharacters (lib.toLower x);
    in
    lib.concatStrings ([ (lib.toUpper (builtins.head chars)) ] ++ (builtins.tail chars));
in
{
  options.wayland.desktopManager.sidonia.keybinds = lib.mkOption {
    description = "List of keybinds to add to the desktop environment";
    type = lib.types.listOf (
      lib.types.submodule {
        options = {
          name = lib.mkOption {
            description = "Name of the bound command";
            type = lib.types.str;
          };
          mod = lib.mkOption {
            description = "Modifier keys";
            type =
              with lib.types;
              coercedTo str (x: [ x ]) (
                listOf (
                  coercedTo str (capitalize) (enum [
                    "Super"
                    "Shift"
                    "Ctrl"
                    "Alt"
                  ])
                )
              );
            default = [ ];
          };
          key = lib.mkOption {
            description = "Key";
            type = lib.types.str;
          };
          exec = lib.mkOption {
            description = "Command to execute";
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
          perCompositor = {
            niri = lib.mkOption {
              description = "Niri specific keybind config";
              type = lib.types.nullOr lib.types.attrs;
              default = null;
            };
          };
        };
      }
    );
  };
  config =
    let
      execs = builtins.filter (x: x.exec != null) cfg.keybinds;
      niriBinds = builtins.filter (x: x.perCompositor.niri != null) cfg.keybinds;
    in
    lib.mkIf osConfig.sidonia.desktop.enable (
      lib.mkMerge [
        (lib.mkIf (osConfig.sidonia.desktop.compositor == "niri") {
          wayland.windowManager.niri.settings.binds = lib.mkMerge (
            (map (x: {
              "${lib.concatStringsSep "+" (x.mod ++ [ x.key ])}" = {
                _props.hotkey-overlay-title = x.name;
                spawn = "${pkgs.writeScript x.name x.exec}";
              };
            }) execs)
            ++ (map (x: {
              "${lib.concatStringsSep "+" (x.mod ++ [ x.key ])}" = {
                _props.hotkey-overlay-title = x.name;
              }
              // x.perCompositor.niri;
            }) niriBinds)
          );
        })
      ]
    );
}
