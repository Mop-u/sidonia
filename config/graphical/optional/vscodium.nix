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
{
    options.sidonia.programs.vscodium.enable =
        with lib;
        mkOption {
            type = types.bool;
            default = cfg.graphics.enable;
        };
    config = lib.mkIf (cfg.programs.vscodium.enable) {
        home-manager.users.${cfg.userName} = {
            catppuccin.vscode.profiles.default = {
                enable = true;
                inherit (theme) accent flavor;
            };
            programs.vscode = {
                enable = true;
                package = pkgs.vscodium;
                profiles.default = {
                    enableExtensionUpdateCheck = false;
                    enableUpdateCheck = false;
                    extensions = with pkgs.vscode-extensions; [
                        haskell.haskell
                        jnoortheen.nix-ide
                        llvm-vs-code-extensions.vscode-clangd
                        mkhl.direnv
                        gruntfuggly.triggertaskonsave
                        christian-kohler.path-intellisense
                        mshr-h.veriloghdl
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
                                        autoEvalInputs = true;
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
