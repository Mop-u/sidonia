{
    nix = {
        extraOptions = ''
            !include access-tokens.conf
        '';
    };
}
