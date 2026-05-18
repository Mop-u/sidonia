{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
{
    programs.helix = {
        enable = lib.mkDefault true;
        defaultEditor = lib.mkDefault true;
        extraPackages = with pkgs; [
            vhdl-ls # vhdl
            haskell-language-server # haskell/cabal
            clang-tools # c/cpp/opencl
            neocmakelsp # cmake
            vscode-json-languageserver # json
            nixd # nix
            marksman # markdown
            zls # zig
            lldb # various debuggers
        ];
        languages = {
            lanaguage = [
                ( rec {
                    name = "nix";
                    indent = { tab-width = 4; unit = "    ";};
                    formatter = {
                        command = "nixfmt";
                        args = ["--indent=${builtins.toString indent.tab-width}"];
                    };
                })
            ];
        };
        settings = {
            editor.bufferline = "multiple";
            keys.normal = lib.mkMerge [
                (lib.mkIf config.programs.lazygit.enable {
                    "C-g" = [
                        ":write-all"
                        ":new"
                        ":insert-output ${lib.getExe config.programs.lazygit.package}"
                        ":buffer-close!"
                        ":redraw"
                        ":reload-all"
                    ];
                })
            ];
        };
    };
}
