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
                        hyprland = lib.mkOption {
                            description = "Hyprland specific keybind config";
                            type = lib.types.nullOr lib.types.str;
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
            hyprBinds = builtins.filter (x: x.perCompositor.hyprland != null) cfg.keybinds;
            hyprToNiri = {
                "mouse:272" = "MouseLeft";
                "mouse:273" = "MouseRight";
                "mouse:274" = "MouseMiddle";
                "mouse:275" = "MouseForward";
                "mouse:276" = "MouseBack";
                "mouse_up" = "WheelScrollDown";
                "mouse_down" = "WheelScrollUp";
            };
            niriToHypr = builtins.listToAttrs (
                builtins.map (x: {
                    name = x.value;
                    value = x.name;
                }) (lib.attrsToList hyprToNiri)
            );
            translate = table: key: table.${key} or key;
        in
        lib.mkIf osConfig.sidonia.desktop.enable (
            lib.mkMerge [
                (lib.mkIf (osConfig.sidonia.desktop.compositor == "hyprland") {
                    wayland.windowManager.hyprland.settings.bind =
                        (builtins.map (
                            x: "${lib.concatStrings x.mod}, ${translate niriToHypr x.key}, exec, uwsm app -- ${x.exec} #\"${x.name}\""
                        ) execs)
                        ++ (builtins.map (
                            x: "${lib.concatStrings x.mod}, ${translate niriToHypr x.key}, ${x.perCompositor.hyprland} #\"${x.name}\""
                        ) hyprBinds);
                })
                (lib.mkIf (osConfig.sidonia.desktop.compositor == "niri") {
                    programs.niri.settings.binds = lib.mkMerge (
                        (builtins.map (x: {
                            "${lib.concatStringsSep "+" (x.mod ++ [ (translate hyprToNiri x.key) ])}" = {
                                hotkey-overlay.title = x.name;
                                action.spawn = "${pkgs.writeScript x.name x.exec}";
                            };
                        }) execs)
                        ++ (builtins.map (x: {
                            "${lib.concatStringsSep "+" (x.mod ++ [ (translate hyprToNiri x.key) ])}" = {
                                hotkey-overlay.title = x.name;
                            }
                            // x.perCompositor.niri;
                        }) niriBinds)
                    );
                })
            ]
        );
}
