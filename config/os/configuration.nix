# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
in
{
    boot.initrd.systemd.enable = true;

    nix.settings = {
        auto-optimise-store = true;
        trusted-users = [ cfg.userName ];
        fallback = lib.mkDefault true;
    };

    catppuccin = {
        enable = true;
        accent = cfg.style.catppuccin.accent;
        flavor = cfg.style.catppuccin.flavor;
    };

    # Enable Graphics
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };

    # Firmware updater
    services.fwupd.enable = true;

    services.fstrim.enable = true;
    services.dbus.implementation = "broker";
    services.irqbalance.enable = true;

    # Enable networking
    networking.networkmanager = {
        enable = true;
        wifi = {
            backend = "iwd";
            powersave = true;
        };
        dns = "systemd-resolved";
    };
    networking.nftables.enable = true;
    networking.firewall.enable = true;

    # Enable local service discovery
    networking.firewall.allowedUDPPorts = [ 5353 ];
    services.resolved = {
        enable = true;
        llmnr = "true"; # true/false/resolve
        dnsovertls = "opportunistic";
    };
    services.avahi = {
        enable = true;
        nssmdns4 = true;
        nssmdns6 = true;
        openFirewall = true;
    };

    # Enable printing
    services.printing.enable = true;

    # Enable bluetooth
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    services.upower.enable = true;
    services.tuned.enable = true;

    # Set your time zone.
    time.timeZone = lib.mkDefault "Europe/Dublin";
    #services.automatic-timezoned.enable = true;
    services.localtimed.enable = cfg.geolocation.enable;
    services.geoclue2 = {
        enable = cfg.geolocation.enable;
        geoProviderUrl = "https://beacondb.net/v1/geolocate";
    };

    # Select internationalisation properties.
    i18n.defaultLocale = "en_GB.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_IE.UTF-8";
        LC_IDENTIFICATION = "en_IE.UTF-8";
        LC_MEASUREMENT = "en_IE.UTF-8";
        LC_MONETARY = "en_IE.UTF-8";
        LC_NAME = "en_IE.UTF-8";
        LC_NUMERIC = "en_IE.UTF-8";
        LC_PAPER = "en_IE.UTF-8";
        LC_TELEPHONE = "en_IE.UTF-8";
        LC_TIME = "en_IE.UTF-8";
    };

    console.keyMap = cfg.input.keyLayout;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${cfg.userName} = {
        isNormalUser = true;
        description = cfg.lib.capitalize cfg.userName;
        extraGroups = [
            "networkmanager"
            "wheel"
        ];
        packages = with pkgs; [ ];
        shell = pkgs.zsh;
    };
    programs.zsh.enable = true;
    programs.direnv.enable = true;
    programs.git = {
        enable = true;
        lfs.enable = true;
    };

    # Enable experimental features
    nix.settings.experimental-features = [
        "nix-command"
        "flakes"
    ];

    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        _7zz
        sops
        vim
        bash
        lshw
        wget
        curl
        tmux
        samba
        age
        ssh-to-age
        fastfetch
        nil
        gnumake
        gcc
        foot.terminfo
        smartmontools
        usbutils
        lm_sensors
        nixfmt
    ];

    fonts = {
        fontDir.enable = true;
        packages =
            with pkgs;
            [
                # 25.05 / unstable
                nerd-fonts.comic-shanns-mono
                nerd-fonts.ubuntu
                liberation_ttf
                meslo-lgs-nf
                dejavu_fonts
            ]
            ++ (lib.optional cfg.text.comicCode.enable cfg.text.comicCode.package);
        fontconfig.defaultFonts = {
            monospace = (lib.optional cfg.text.comicCode.enable cfg.text.comicCode.name) ++ [
                "ComicShannsMono Nerd Font"
            ];
        };
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = cfg.stateVer;
}
