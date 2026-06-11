{
  description = "Opinionated nixos configuration overlay";

  inputs = {
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    moppkgs.url = "github:Mop-u/moppkgs";
    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
    dw-proton.url = "github:imaviso/dwproton-flake";
    niri.url = "git+https://codeberg.org/BANanaD3V/niri-nix";
    helix.url = "github:helix-editor/helix";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    scopebuddy = {
      url = "github:OpenGamingCollective/ScopeBuddy";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix/release-26.05";
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
    {
      nixosModules = {
        sidonia = (import ./module.nix) inputs;
        default = self.nixosModules.sidonia;
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
                (self.nixosModules.sidonia)
                (lib.path.append dir hostName)
              ]
              ++ modules;
            });

          allConfigs = lib.mapAttrs (n: v: (mkConfig n)) hosts;
        in
        allConfigs;
    };
}
