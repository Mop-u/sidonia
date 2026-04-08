{
    description = "Opinionated nixos configuration overlay";

    inputs = {
        unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
        nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
        moppkgs.url = "github:Mop-u/moppkgs";
        noctalia.url = "github:noctalia-dev/noctalia-shell";
        dw-proton.url = "github:imaviso/dwproton-flake";
        cachyos.url = "github:xddxdd/nix-cachyos-kernel";

        home-manager = {
            url = "github:nix-community/home-manager/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        catppuccin = {
            url = "github:catppuccin/nix/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        hyprland.url = "github:hyprwm/Hyprland/v0.54.2";
        split-monitor-workspaces = {
            url = "github:zjeffer/split-monitor-workspaces/34c266b732d8a063213098dc88369ac88b95dfa1";
            inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
        };
        hyprland-plugins = {
            url = "github:hyprwm/hyprland-plugins";
            inputs.hyprland.follows = "hyprland";
        };

        scopebuddy = {
            url = "github:OpenGamingCollective/ScopeBuddy";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        aagl = {
            url = "github:ezKEa/aagl-gtk-on-nix/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        niri = {
            url = "github:sodiboo/niri-flake";
            inputs.nixpkgs.follows = "unstable";
            inputs.nixpkgs-stable.follows = "nixpkgs";
        };

        nix-vscode-extensions = {
            url = "github:nix-community/nix-vscode-extensions";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # sublime text packages
        stextPackageControl = {
            url = "github:wbond/package_control";
            flake = false;
        };
        stextCatppuccin = {
            url = "github:catppuccin/sublime-text";
            flake = false;
        };

    };

    outputs =
        { self, nixpkgs, ... }@inputs:
        rec {
            nixosModules = rec {
                sidonia = (import ./module.nix) { inherit inputs; };
                default = sidonia;
            };
            mkSidonia =
                dir:
                {
                    specialArgs ? { },
                    modules ? [ ],
                }:
                let
                    inherit (nixpkgs) lib;

                    hosts = lib.filterAttrs (n: v: v == "directory") (builtins.readDir dir);

                    mkConfig =
                        hostName:
                        let
                            otherHostNames = lib.filterAttrs (n: v: n != hostName) hosts;
                            otherHosts = lib.mapAttrsToList (n: v: { inherit (allConfigs.${n}) config; }) otherHostNames;
                        in
                        (lib.nixosSystem {
                            specialArgs = {
                                inherit otherHosts;
                            }
                            // specialArgs;
                            modules = [
                                nixosModules.sidonia
                                (lib.path.append dir hostName)
                            ]
                            ++ modules;
                        });

                    allConfigs = lib.mapAttrs (n: v: (mkConfig n)) hosts;
                in
                allConfigs;
        };
}
