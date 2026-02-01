{
    description = "Opinionated nixos configuration overlay";

    inputs = {
        unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
        nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";

        home-manager = {
            url = "github:nix-community/home-manager/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        catppuccin = {
            url = "github:catppuccin/nix/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        hyprland = {
            url = "github:hyprwm/Hyprland";
            inputs.nixpkgs.follows = "unstable";
        };

        hyprshell = {
            url = "github:H3rmt/hyprshell/hyprshell-release";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.hyprland.follows = "hyprland";
        };

        aagl = {
            url = "github:ezKEa/aagl-gtk-on-nix/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nix-std = {
            url = "github:chessai/nix-std";
        };

        nix-auth = {
            url = "github:numtide/nix-auth";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        niri = {
            url = "github:sodiboo/niri-flake";
            inputs.nixpkgs.follows = "unstable";
            inputs.nixpkgs-stable.follows = "nixpkgs";
        };

        affinity = {
            url = "github:mrshmllow/affinity-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nonfree-fonts = {
            url = "github:Mop-u/nonfree-fonts";
            inputs.nixpkgs.follows = "nixpkgs";
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
                                std = inputs.nix-std.lib;
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
