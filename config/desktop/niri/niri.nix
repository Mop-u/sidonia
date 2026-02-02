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
    config = lib.mkIf (cfg.desktop.enable && (cfg.desktop.compositor == "niri")) {
        home-manager.users.${cfg.userName}.programs.niri = {
            enable = true;
            package = pkgs.niri-stable;
            settings = {
                environment = cfg.desktop.environment.niri;
            };
        };
    };
}
