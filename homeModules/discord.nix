{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
{
  options.catppuccin.discord.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.catppuccin.enable;
  };
  config =
    let
      # https://github.com/nix-community/home-manager/blob/master/modules/programs/discord.nix
      configDir =
        if pkgs.stdenv.hostPlatform.isDarwin then "Library/Application Support" else config.xdg.configHome;
    in
    lib.mkIf config.programs.discord.enable (
      lib.mkMerge [
        (lib.mkIf osConfig.sidonia.graphics.legacyGpu {
          home.packages = [
            (osConfig.sidonia.lib.addDesktopFlags config.programs.discord.package "discord" [ "--disable-gpu" ])
          ];
        })
        (lib.mkIf config.catppuccin.discord.enable {
          programs.discord.package = pkgs.discord.override {
            withOpenASAR = false;
            withVencord = true;
          };

          # home-manager has issues with the backup files here
          home.file."${configDir}/${config.programs.discord.configName}/settings.json".force = true;

          xdg.configFile."Vencord/settings/quickCss.css" = {
            enable = config.catppuccin.discord.enable;
            text = ''
              @import url("https://catppuccin.github.io/discord/dist/catppuccin-${config.catppuccin.flavor}.theme.css");
              @import url("https://catppuccin.github.io/discord/dist/catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}.theme.css");
            '';
          };
        })
      ]
    );
}
