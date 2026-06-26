{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.catppuccin.noctalia;
  mkHex = lib.mapAttrs (n: v: "#${v}");
  lightTheme =
    let
      x = (import ../lib/catppuccin.nix).latte;
    in
    mkHex (x // { accent = x.${cfg.accent}; });
  theme = mkHex config.catppuccin.lib.color;

  replaceWith =
    regex: replace: string:
    let
      matches = builtins.match regex string;
    in
    if ((isNull matches) || (builtins.any isNull matches)) then
      string
    else
      lib.concatStrings (lib.zipListsWith (a: b: (a b)) replace matches);
  replaceByLine =
    regex: replace: string:
    lib.concatLines (map (replaceWith regex replace) (lib.splitString "\n" string));

  termTheme = fromTOML (
    # Add quotes to ini values to make them readable by fromTOML
    replaceByLine ''(^[_a-zA-Z0-9\-]+=)(.*$)''
      [
        (m: m)
        (m: ''"${m}"'')
      ]
      (
        builtins.readFile "${config.catppuccin.sources.foot}/catppuccin-${config.catppuccin.noctalia.flavor}.ini"
      )
  );

  paletteName = "catppuccin-${cfg.flavor}-${cfg.accent}";

  mkPalette =
    main: term:
    (with main; rec {
      mPrimary = accent;
      mSecondary = peach;
      mTertiary = teal;
      mError = red;
      mHover = mTertiary;

      mSurface = base;
      mOnSurface = text;
      mSurfaceVariant = surface0;
      mOnSurfaceVariant = subtext0;
      mOutline = surface1;

      mOnPrimary = crust;
      mOnSecondary = crust;
      mOnTertiary = crust;
      mOnError = crust;
      mShadow = crust;
      mOnHover = crust;
    })
    // (with term; {
      terminal =
        let
          split = lib.splitString " " cursor;
        in
        {
          inherit foreground background;
          selectionFg = selection-foreground;
          selectionBg = selection-background;
          cursorText = builtins.elemAt split 0;
          cursor = builtins.elemAt split 1;
          normal = {
            black = regular0;
            red = regular1;
            green = regular2;
            yellow = regular3;
            blue = regular4;
            magenta = regular5;
            cyan = regular6;
            white = regular7;
          };
          bright = {
            black = bright0;
            red = bright1;
            green = bright2;
            yellow = bright3;
            blue = bright4;
            magenta = bright5;
            cyan = bright6;
            white = bright7;
          };
        };
    });

in
{
  options.catppuccin.noctalia = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.catppuccin.enable;
    };
    flavor = lib.mkOption {
      type = lib.types.str;
      default = config.catppuccin.flavor;
    };
    accent = lib.mkOption {
      type = lib.types.str;
      default = config.catppuccin.accent;
    };
  };
  config = lib.mkIf (config.programs.noctalia.enable && cfg.enable) {
    xdg.configFile."noctalia/palettes/${paletteName}.json".text = builtins.toJSON {
      dark = mkPalette theme termTheme.colors-dark;
      light = mkPalette lightTheme (termTheme.colors-light or termTheme.colors-dark);
    };
    programs.noctalia.settings = {
      theme = {
        mode = if cfg.flavor == "latte" then "light" else "dark";
        source = "custom";
        custom_palette = paletteName;
        builtin = "Catppuccin";
      };
    };
  };
}
