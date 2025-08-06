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
lib.mkIf (cfg.graphics.enable) {

    home-manager.users.${cfg.userName} = {

        dconf.settings = with lib.gvariant; {
            "org/gnome/desktop/interface" = {
                cursor-size = mkInt32 cfg.style.cursorSize;
            };
            "org/cinnamon/desktop/default-applications/terminal" = {
                exec = mkValue "foot";
                exec-arg = mkValue "-e";
            };
            "org/gnome/desktop/applications/terminal" = {
                exec = mkValue "foot";
                exec-arg = mkValue "-e";
            };
            "org/gnome/desktop/interface" = {
                color-scheme = if theme.flavor == "latte" then "prefer-light" else "prefer-dark";
            };
        };
        gtk = {
            enable = true;
            iconTheme = lib.mkDefault {
                name = "Papirus";
                package = pkgs.catppuccin-papirus-folders.override {
                    flavor = theme.flavor;
                    accent = theme.accent;
                };
            };
            theme =
                let
                    baseName = "Catppuccin-GTK";
                    shade = if theme.flavor == "latte" then "light" else "dark";
                    doTweak = builtins.elem theme.flavor [
                        "frappe"
                        "macchiato"
                    ];
                in
                {
                    package = pkgs.magnetic-catppuccin-gtk.overrideAttrs (
                        let
                            size = "standard";
                            tweaks = lib.optional doTweak theme.flavor;
                            accent = [ theme.accent ];
                        in
                        {
                            src = cfg.src.magnetic-catppuccin-gtk;

                            installPhase = ''
                                runHook preInstall

                                mkdir -p $out/share/themes
                                ./themes/install.sh \
                                  --name ${baseName} \
                                  ${toString (map (x: "--theme " + x) accent)} \
                                  ${lib.optionalString (shade != null) ("--color " + shade)} \
                                  ${lib.optionalString (size != null) ("--size " + size)} \
                                  ${toString (map (x: "--tweaks " + x) tweaks)} \
                                  --dest $out/share/themes

                                jdupes --quiet --link-soft --recurse $out/share

                                runHook postInstall
                            '';
                        }
                    );
                    name = lib.strings.concatStringsSep "-" (
                        [
                            baseName
                            (cfg.lib.capitalize theme.accent)
                            (cfg.lib.capitalize shade)
                        ]
                        ++ (lib.optional doTweak (cfg.lib.capitalize theme.flavor))
                    );
                };
        };
    };
}
