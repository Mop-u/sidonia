{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
{
    options.catppuccin.bemenu.enable = lib.mkOption {
        type = lib.types.bool;
        default = config.catppuccin.enable;
    };
    config = lib.mkIf (config.programs.bemenu.enable && config.catppuccin.bemenu.enable) {
        programs.bemenu.settings =
            with builtins.mapAttrs (n: v: "#${v}") config.catppuccin.lib.color;
            builtins.mapAttrs (n: v: lib.mkDefault v) {
                tb = base;
                fb = base;
                nb = base;
                ab = base;
                hb = base;
                tf = accent;
                ff = text;
                nf = text;
                af = text;
                hf = accent;
                bdr = accent;
                fn = "monospace";
            };
    };
}
