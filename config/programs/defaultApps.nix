{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
in
lib.mkMerge [
    (lib.mkIf cfg.desktop.enable {
        home-manager.users.${cfg.userName} = {
            programs = {
                discord.enable = lib.mkDefault true;
                vesktop.enable = lib.mkDefault true;
                obs-studio = {
                    enable = lib.mkDefault true;
                    plugins = with pkgs.obs-studio-plugins; [
                        wlrobs
                    ];
                };
            };
            home.packages = with pkgs; [
                # GUI apps
                pinta # Paint.NET-like image editor
                #plex-desktop # doesn't launch
                heroic
                protonvpn-gui
                slack
                prismlauncher
                #xivlauncher
                plexamp
                surfer
                bambu-studio
                tageditor
                affinity
            ];
        };
    })
    {
        home-manager.users.${cfg.userName} = {
            catppuccin.nvim.enable = lib.mkDefault true;
            programs = {
                btop.enable = lib.mkDefault true;
                neovim = {
                    enable = lib.mkDefault true;
                    defaultEditor = lib.mkDefault true;
                };
            };
        };
    }
]
