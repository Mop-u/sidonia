{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
    theme = cfg.style.catppuccin;
    vsxOverlay =
        final: prev:
        let
            getVsxVersion = pkg: lib.versions.pad 3 pkg.version;
            getFlakeExts =
                version:
                cfg.src.nix-vscode-extensions.extensions.${final.stdenv.hostPlatform.system}.forVSCodeVersion
                    version;
            overlayExtensions =
                pkg:
                with getFlakeExts (getVsxVersion pkg);
                lib.zipAttrsWith (name: values: (lib.mergeAttrsList values)) [
                    final.vscode-extensions
                    open-vsx
                    open-vsx-release
                    vscode-marketplace
                    vscode-marketplace-release
                ];
        in
        {
            vsxExtensionsFor = overlayExtensions;
        };
in
{
    options.sidonia.programs.vscodium.enable =
        with lib;
        mkOption {
            type = types.bool;
            default = cfg.desktop.enable;
        };
    config = lib.mkIf (cfg.programs.vscodium.enable) {
        nixpkgs.overlays = [ vsxOverlay ];
        home-manager.users.${cfg.userName} = {
            nixpkgs.overlays = [ vsxOverlay ];
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
