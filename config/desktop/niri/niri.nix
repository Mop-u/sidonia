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
    # see: https://github.com/linuxmobile/kaku/blob/niri/home/software/wayland/niri/settings.nix
    # see: https://github.com/sodiboo/niri-flake/blob/main/docs.md
    config = lib.mkIf (cfg.graphics.enable) {
        home-manager.users.${cfg.userName}.programs.niri = {
            enable = false;
            package = pkgs.niri-stable;
            settings = {
                environment = cfg.desktop.environment.niri;
            };
        };
    };
}
