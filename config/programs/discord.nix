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
    options.sidonia.programs.discord = with lib; {
        enable = mkOption {
            type = types.bool;
            default = cfg.desktop.enable;
        };
        withVencord = mkOption {
            description = "Use Vencord (This allows catppuccin theming)";
            type = types.bool;
            default = true;
        };
    };
    config =
        let
            withVencord = cfg.programs.discord.withVencord;
        in
        lib.mkIf (cfg.programs.discord.enable) {

            home-manager.users.${cfg.userName} = {
                home.packages = [
                    (pkgs.discord.override {
                        withOpenASAR = true;
                        withVencord = withVencord;
                    })
                ];

                xdg.configFile."Vencord/settings/quickCss.css" = {
                    enable = withVencord;
                    text = ''
                        @import url("https://catppuccin.github.io/discord/dist/catppuccin-${cfg.style.catppuccin.flavor}.theme.css");
                        @import url("https://catppuccin.github.io/discord/dist/catppuccin-${cfg.style.catppuccin.flavor}-${cfg.style.catppuccin.accent}.theme.css");
                    '';
                };

            };
        };
}
