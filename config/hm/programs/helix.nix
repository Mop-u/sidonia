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
            slang-server # verilog/systemverilog
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
            language = [
                {
                    name = "nix";
                    indent = {
                        tab-width = 4;
                        unit = "    ";
                    };
                }
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
