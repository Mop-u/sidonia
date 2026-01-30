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
        affinity = inputs.affinity.packages.${getSystem prev}.v3;
        nix-auth = inputs.nix-auth.packages.${getSystem prev}.default;
        inherit (inputs.unstable.legacyPackages.${getSystem prev})
            magnetic-catppuccin-gtk
            surfer
            ;
        inherit (inputs.hyprland.packages.${getSystem prev})
            hyprland
            xdg-desktop-portal-hyprland
            ;
        inherit (inputs.hyprshell.packages.${getSystem prev})
            hyprshell-nixpkgs
            hyprshell
            ;
        sublimePackages = {
            "Catppuccin color schemes" = inputs.stextCatppuccin;
            "Package Control" = inputs.stextPackageControl;
        };
    })
    (overlayMissingFromFlake inputs.nixpkgs-xr) # use nixpkgs stable where possible
    inputs.nur.overlays.default
    inputs.niri.overlays.niri
]
