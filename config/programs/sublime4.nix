{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
in
lib.mkIf cfg.desktop.enable {

    nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1w" ];

    home-manager.users.${cfg.userName} = {
        programs.sublime4 = {
            enable = true;
            settings = {
                ignored_packages = [ "Vintage" ];
                font_size = 10;
                translate_tabs_to_spaces = true;
                index_files = true;
                hardware_acceleration = if cfg.graphics.legacyGpu then "none" else "opengl";
                theme = "Adaptive.sublime-theme";
                update_check = false;
                sublime_merge_path = lib.getExe pkgs.sublime-merge;
            };
            userFile = {
                "SystemVerilog.sublime-settings".text = builtins.toJSON {
                    "sv.disable_autocomplete" = true;
                    "sv.tooltip" = true;
                };
            };
            packages = {
                inherit (pkgs.sublimePackages)
                    "Package Control"
                    LSP
                    Nix
                    SystemVerilog
                    hooks
                    ;
            };
        };
        programs.sublime-merge = {
            enable = true;
            settings = {
                translate_tabs_to_spaces = true;
                side_bar_layout = "tabs";
                font_size = 10;
                hardware_acceleration = if cfg.graphics.legacyGpu then "none" else "opengl";
                update_check = false;
                editor_path = "${pkgs.sublime4}/bin/sublime_text";
            };
        };
    };
}
