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
    options.sidonia.programs.vscodium.enable =
        with lib;
        mkOption {
            type = types.bool;
            default = cfg.desktop.enable;
        };
    config = lib.mkIf (cfg.programs.vscodium.enable) {
        home-manager.users.${cfg.userName} = {
            programs.vscode = {
                enable = true;
                package = pkgs.vscodium;
                profiles.default = {
                    enableExtensionUpdateCheck = false;
                    enableUpdateCheck = false;
                    extensions = with pkgs.vsxExtensionsFor pkgs.vscodium; [
                        haskell.haskell
                        jnoortheen.nix-ide
                        mkhl.direnv
                    ];
                    userSettings =
                        let
                            nixfmt = [
                                "nixfmt"
                                "--indent=4"
                            ];
                        in
                        {
                            "typescript.suggest.paths" = false;
                            "javascript.suggest.paths" = false;
                            "nix.enableLanguageServer" = true;
                            "nix.formatterPath" = nixfmt;
                            "nix.serverPath" = "nil";
                            "nix.serverSettings" = {
                                nil = {
                                    diagnostics.ignored = [
                                        "unused_binding"
                                        "unused_with"
                                    ];
                                    formatting.command = nixfmt;
                                    nix.flake = {
                                        autoArchive = true;
                                        autoEvalInputs = false;
                                        nixpkgsInputName = "nixpkgs";
                                    };
                                };
                            };
                            "editor.fontFamily" = "monospace, 'ComicShannsMono Nerd Font'";
                        };
                };
            };
        };
    };
}
