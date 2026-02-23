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
lib.mkIf (cfg.desktop.enable) {
    home.packages = with pkgs; [
        mate.engrampa # archive manager
        ffmpegthumbnailer
        webp-pixbuf-loader
        cinnamon-gsettings-overrides
        ((nemo-with-extensions.overrideAttrs { extraNativeBuildInputs = [ pkgs.gvfs ]; }).override {
            extensions = [
                folder-color-switcher
                nemo-emblems
                nemo-fileroller
                nemo-python
                nemo-preview
                nemo-seahorse
            ];
            useDefaultExtensions = false;
        })
    ];
    xdg.mimeApps.defaultApplications =
        let
            fileExplorer = "nemo.desktop";
        in
        {
            "inode/directory" = [ fileExplorer ];
            "application/x-gnome-saved-search" = [ fileExplorer ];
        };
}
