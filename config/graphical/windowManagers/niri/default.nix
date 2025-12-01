{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
    theme = cfg.style.catppuccin;
in
{
    imports = [
        #./niri.nix
        #./cosmicOnNiri.nix
    ];
}
