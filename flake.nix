{
    description = "Opinionated nixos configuration overlay";

    inputs = {
        unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
        nixfmt-git.url = "github:NixOS/nixfmt";
        nix-colors.url = "github:misterio77/nix-colors";

        aagl = {
            url = "github:ezKEa/aagl-gtk-on-nix/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        hyprswitch = {
            url = "github:h3rmt/hyprswitch/old-release-hyprswitch";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        hyprshell = {
            url = "github:h3rmt/hyprswitch/hyprshell-release";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nur = {
            url = "github:nix-community/NUR";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        catppuccin.url = "github:catppuccin/nix/release-25.05";

        affinity = {
            url = "github:mrshmllow/affinity-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixpkgs-xr = {
            url = "github:nix-community/nixpkgs-xr";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nonfree-fonts = {
            url = "github:Mop-u/nonfree-fonts";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

        # sublime text packages
        stextPackageControl = {
            url = "github:wbond/package_control";
            flake = false;
        };
        stextLSP = {
            url = "github:sublimelsp/LSP";
            flake = false;
        };
        stextNix = {
            url = "github:wmertens/sublime-nix";
            flake = false;
        };
        stextCatppuccin = {
            url = "github:catppuccin/sublime-text";
            flake = false;
        };
        stextSystemVerilog = {
            url = "github:TheClams/SystemVerilog";
            flake = false;
        };
        stextHooks = {
            url = "github:twolfson/sublime-hooks";
            flake = false;
        };

        # get up-to-date kmscon version
        kmscon = {
            url = "github:Aetf/kmscon/main";
            flake = false;
        };
        libtsm = {
            url = "github:Aetf/libtsm/main";
            flake = false;
        };

        # get up-to-date magnetic-catppuccin-gtk
        magnetic-catppuccin-gtk = {
            url = "github:Fausto-Korpsvart/Catppuccin-GTK-Theme";
            #url = "github:Mop-u/Catppuccin-GTK-Theme/fix-theme-variants-index";
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
