{ inputs, lib }:
let
    getSystem = overlayPkgs: overlayPkgs.stdenv.hostPlatform.system;
    overlayMissingFromFlake =
        flake:
        (
            final: prev:
            if builtins.hasAttr (getSystem prev) flake.packages then
                lib.filterAttrs (n: v: !(builtins.hasAttr n prev)) flake.packages.${getSystem prev}
            else
                { }
        );
in
[
    inputs.moppkgs.overlays.default
    inputs.cachyos.overlays.pinned
    inputs.noctalia.overlays.default
    inputs.niri.overlays.niri
    (
        final: prev:
        let
            getVsxVersion = pkg: lib.versions.pad 3 pkg.version;
            getFlakeExts =
                version: inputs.nix-vscode-extensions.extensions.${getSystem prev}.forVSCodeVersion version;
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
        }
    )
    (final: prev: {
        inherit (inputs.unstable.legacyPackages.${getSystem prev})
            magnetic-catppuccin-gtk
            surfer
            ;

        scopebuddy = inputs.scopebuddy.packages.${getSystem prev}.default;

        sublimePackages = {
            "Catppuccin color schemes" = inputs.stextCatppuccin;
            "Package Control" = inputs.stextPackageControl;
        };

        dwproton = inputs.dw-proton.packages.${getSystem prev}.default;

        noctalia-shell = inputs.noctalia.packages.${getSystem prev}.default;
    })
    (overlayMissingFromFlake inputs.nixpkgs-xr) # use nixpkgs stable where possible
]
