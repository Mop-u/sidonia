{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
{
    programs.helix = {
        extraPackages = with pkgs; [
            ghc
            haskell-language-server
            fourmolu
        ];
        languages = {
            lanaguage = [
                {
                    name = "haskell";
                    indent = {
                        tab-width = 4;
                        unit = "    ";
                    };
                    formatter = {
                        command = lib.getExe pkgs.zsh;
                        args = [
                            "-c"
                            "fourmolu --stdin-input-file $(pwd)"
                        ];
                    };
                }
            ];
        };
    };
}
