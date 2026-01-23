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
lib.mkIf (cfg.desktop.enable) {

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
                    shade = if theme.flavor == "latte" then "light" else "dark";
                    doTweak = builtins.elem theme.flavor [
                        "frappe"
                        "macchiato"
                    ];
                in
                {
                    package = pkgs.magnetic-catppuccin-gtk.override {
                        inherit shade;
                        tweaks = lib.optional doTweak theme.flavor;
                        accent = [ theme.accent ];
                    };
                    name = lib.strings.concatStringsSep "-" (
                        [
                            "Catppuccin-GTK"
                            (cfg.lib.capitalize theme.accent)
                            (cfg.lib.capitalize shade)
                        ]
                        ++ (lib.optional doTweak (cfg.lib.capitalize theme.flavor))
                    );
                };
        };
    };
}
