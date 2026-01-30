{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
in
lib.mkMerge [
    (lib.mkIf cfg.desktop.enable {
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
            bambu-studio
            tageditor
            affinity
        ];
    })
    {
        programs = {
            btop.enable = lib.mkDefault true;
            neovim = {
                enable = lib.mkDefault true;
                defaultEditor = lib.mkDefault true;
            };
            bat = {
                enable = lib.mkDefault true;
                config = {
                    style = "plain";
                    paging = "never";
                };
            };
        };
    }
]
