{
    osConfig,
    config,
    lib,
    pkgs,
    ...
}:
let
    cfg = osConfig.sidonia;
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
                            listOf (
                                coercedTo str (lib.toLower) (enum [
                                    "super"
                                    "shift"
                                    "ctrl"
                                    "alt"
                                ])
                            );
                    };
                    key = lib.mkOption {
                        description = "Key";
                        type = lib.types.str;
                    };
                    exec = lib.mkOption {
                        description = "Command to execute";
                        type = lib.types.str;
                    };
                };
            }
        );
    };
}
