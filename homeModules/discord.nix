{
    config,
    pkgs,
    lib,
    ...
}:
{
    options.catppuccin.discord.enable = lib.mkOption {
        type = lib.types.bool;
        default = config.catppuccin.enable;
    };
    config = lib.mkIf (config.programs.discord.enable && config.catppuccin.discord.enable) {
        programs.discord.package = pkgs.discord.override {
            withOpenASAR = true;
            withVencord = true;
        };

        xdg.configFile."Vencord/settings/quickCss.css" = {
            enable = config.catppuccin.discord.enable;
            text = ''
                @import url("https://catppuccin.github.io/discord/dist/catppuccin-${config.catppuccin.flavor}.theme.css");
                @import url("https://catppuccin.github.io/discord/dist/catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}.theme.css");
            '';
        };
    };
}
