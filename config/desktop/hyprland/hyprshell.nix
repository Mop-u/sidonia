{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
in
{
    config = lib.mkIf cfg.programs.hyprland.enable {
        home-manager.users.${cfg.userName} = {
            # https://github.com/H3rmt/hyprshell/blob/hyprshell-release/nix/module.nix
            systemd.user.services.hyprshell.Service.Environment = lib.mapAttrsToList (
                n: v: "${n}=${v}"
            ) cfg.desktop.environment.hyprland;
            programs.hyprshell = {
                enable = true;
                package = cfg.src.hyprshell.packages.${pkgs.stdenv.hostPlatform.system}.hyprshell-nixpkgs;
                systemd.args = "-v";
                settings = {
                    windows = {
                        enable = true;
                        overview = {
                            enable = true;
                            key = "p";
                            modifier = "super";
                            launcher = {
                                default_terminal = "foot";
                                max_items = 6;
                                plugins = {
                                    shell.enable = true;
                                    terminal.enable = false;
                                };
                            };
                        };
                        switch = {
                            enable = false;
                            modifier = "super";
                        };
                    };
                };
            };
        };
    };
}
