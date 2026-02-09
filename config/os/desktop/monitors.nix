{
    config,
    lib,
    pkgs,
    ...
}:
{
    options.sidonia.desktop.monitors = lib.mkOption {
        description = "List of monitor configurations ( see https://wiki.hyprland.org/Configuring/Monitors/ )";
        type = lib.types.listOf (
            lib.types.submodule {
                options = {
                    name = lib.mkOption {
                        description = "Name of monitor";
                        type = lib.types.str;
                    };
                    resolution = lib.mkOption {
                        type =
                            lib.types.either
                                (lib.types.enum [
                                    "preferred"
                                    "highres"
                                    "highrr"
                                    "maxwidth"
                                ])
                                (
                                    lib.types.submodule {
                                        options = {
                                            x = lib.mkOption {
                                                type = lib.types.int;
                                            };
                                            y = lib.mkOption {
                                                type = lib.types.int;
                                            };
                                            hz = lib.mkOption {
                                                type =
                                                    with lib.types;
                                                    nullOr (coercedTo float (lib.strings.floatToString) (coercedTo int (builtins.toString) str));
                                                default = null;
                                            };
                                        };
                                    }
                                );
                        default = "highres";
                    };
                    position = lib.mkOption {
                        description = "Monitor position in scaled pixels WIDTHxHEIGHT";
                        type = lib.types.str;
                        default = "auto";
                    };
                    scale = lib.mkOption {
                        description = "Monitor scale factor";
                        type = lib.types.nullOr lib.types.float;
                        default = null;
                    };
                    bitdepth = lib.mkOption {
                        description = "Monitor bit depth";
                        type = lib.types.nullOr (
                            lib.types.enum [
                                8
                                10
                            ]
                        );
                        default = null;
                    };
                    hdr = lib.mkEnableOption "Enable HDR for this monitor";
                    extraArgs = lib.mkOption {
                        description = "Extra comma-separated monitor properties";
                        type = lib.types.nullOr (lib.types.attrsOf lib.types.str);
                        default = null;
                    };
                };
            }
        );
        default = [ ];
    };
}
