{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
{
    programs.helix = {
        enable = lib.mkDefault true;
        defaultEditor = lib.mkDefault true;
        settings = {
            keys.normal = lib.mkMerge [
                (lib.mkIf config.programs.lazygit.enable {
                    "C-g" = [
                        ":write-all"
                        ":new"
                        ":insert-output ${lib.getExe config.programs.lazygit.package}"
                        ":buffer-close!"
                        ":redraw"
                        ":reload-all"
                    ];
                })
            ];
        };
    };
}
