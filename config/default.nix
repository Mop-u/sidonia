{
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./configuration.nix
        ./programs
        ./services
        ./tweaks
        ./desktop
    ];
    home-manager.users.${config.sidonia.userName}.imports = [ ./homeModules ];
}
