inputs:
{
  config,
  lib,
  pkgs,
  specialArgs,
  otherHosts,
  ...
}:
let
  cfg = config.sidonia;
  fromHexString = hex: (fromTOML "getInt = 0h${hex}").getInt;
in
{
  options = {
    sidonia = {
      lib = lib.mkOption {
        readOnly = true;
        type = lib.types.attrs;
        default = {
          capitalize =
            str:
            let
              chars = lib.stringToCharacters str;
            in
            lib.concatStrings ([ (lib.toUpper (builtins.head chars)) ] ++ (builtins.tail chars));
          fromHexToRgb =
            hex:
            lib.concatStringsSep ", " (
              map (x: toString (fromHexString x)) [
                (builtins.substring 0 2 hex)
                (builtins.substring 2 2 hex)
                (builtins.substring 4 2 hex)
              ]
            );

          home = {
            applications = "/home/${cfg.userName}/.nix-profile/share/applications";
            autostart = "/home/${cfg.userName}/.config/autostart";
          };
          configContainerCredential =
            f: service: path:
            let
              rootCredName = "${service}CredentialRoot";
              localCredName = "${service}CredentialLocal";
            in
            {
              extraFlags = [ "--load-credential=${rootCredName}:${path}" ];
              config = lib.mkMerge [
                { systemd.services."${service}".serviceConfig.LoadCredential = "${localCredName}:${rootCredName}"; }
                (f "/run/credentials/${service}.service/${localCredName}")
              ];
            };
        };
      };
      ssh = {
        pubKey = lib.mkOption {
          type = lib.types.str;
          default = "";
        };
        privKeyPath = lib.mkOption {
          type = lib.types.path;
          default = "/home/${cfg.userName}/.ssh/id_ed25519";
        };
      };
      userName = lib.mkOption {
        description = "Username of main user";
        type = lib.types.str;
      };
      geolocation.enable = lib.mkEnableOption "Turn on geolocation related services such as automatic timezone changing and geoclue";
      isLaptop = lib.mkEnableOption "Apply laptop-specific tweaks";
      graphics.legacyGpu = lib.mkEnableOption "Apply tweaks for OpenGL ES 2 device support";
      text = {
        comicCode = lib.mkOption {
          default = { };
          type = lib.types.submodule {
            options = {
              enable = lib.mkEnableOption "Use Comic Code monospace font";
              ligatures.enable = lib.mkOption {
                description = "Use ligatures by default";
                default = true;
                type = lib.types.bool;
              };
              source = lib.mkOption {
                description = "Source zip file containing the font";
                type = lib.types.nullOr lib.types.path;
                default = null;
              };
            };
          };
          apply = x: {
            inherit (x) enable;
            package =
              if (isNull x.source) then pkgs.comic-code else (pkgs.comic-code.overrideAttrs { src = x.source; });
            name =
              if x.enable then
                if x.ligatures.enable then "Comic Code Ligatures" else "Comic Code"
              else
                "ComicShannsMono Nerd Font";
          };
        };
      };
      desktop = {
        enable = lib.mkEnableOption "Enable desktop environment";
        compositor = lib.mkOption {
          description = "Which compositor to use";
          type = lib.types.enum [
            "niri"
          ];
          default = "niri";
        };
        shell = lib.mkOption {
          description = "What desktop shell to use";
          type = lib.types.enum [
            "noctalia"
          ];
          default = "noctalia";
        };
      };
    };
  };

  imports = with inputs; [
    aagl.nixosModules.default
    catppuccin.nixosModules.catppuccin
    home-manager.nixosModules.home-manager
    niri.nixosModules.default
    nix-monitored.nixosModules.default
    noctalia-greeter.nixosModules.default
    sops-nix.nixosModules.default
  ];

  config =
    let
      overlays = (import ./overlays.nix) { inherit inputs lib; };
    in
    {
      home-manager = {
        backupFileExtension = lib.mkDefault "backup";
        extraSpecialArgs = removeAttrs specialArgs [ "otherHosts" ];
        sharedModules = [
          inputs.catppuccin.homeModules.catppuccin
          inputs.niri.homeModules.default
          inputs.noctalia.homeModules.default
          inputs.zen-browser.homeModules.default
          {
            options.catppuccin.lib.color = lib.mkOption {
              readOnly = true;
              type = lib.types.attrsOf lib.types.str;
              default =
                let
                  theme = (import ./lib/catppuccin.nix).${config.catppuccin.flavor};
                in
                theme
                // {
                  accent = theme.${config.catppuccin.accent};
                };
            };
            config = {
              nixpkgs = {
                inherit overlays;
                config.allowUnfree = true;
              };
              catppuccin = lib.mapAttrs (n: v: lib.mkDefault v) {
                inherit (config.catppuccin) enable accent flavor;
              };
              home.stateVersion = lib.mkDefault config.system.stateVersion;
            };
          }
          ./homeModules
        ];
        users.${cfg.userName} = {
          home = {
            username = config.sidonia.userName;
            homeDirectory = "/home/${config.sidonia.userName}";
          };
        };
      };
      nixpkgs = { inherit overlays; };
    };
}
