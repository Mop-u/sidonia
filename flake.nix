{
  description = "Opinionated nixos configuration overlay";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    aagl.url = "github:ezKEa/aagl-gtk-on-nix/release-26.05";
    catppuccin.url = "github:catppuccin/nix/release-26.05";

    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    helix.url = "github:helix-editor/helix";
    moppkgs.url = "github:Mop-u/moppkgs";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "unstable";
      inputs.home-manager.follows = "home-manager";
    };

    nix-monitored = {
      url = "github:ners/nix-monitored";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dw-proton = {
      url = "github:imaviso/dwproton-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    scopebuddy = {
      url = "github:OpenGamingCollective/ScopeBuddy";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "git+https://codeberg.org/BANanaD3V/niri-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-legacy = {
      url = "github:niri-wm/niri/v25.11";
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
