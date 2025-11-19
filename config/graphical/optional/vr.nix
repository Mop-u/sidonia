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
    options.sidonia.services.vr.enable = with lib; mkEnableOption "Enable VR services";
    config = lib.mkIf (cfg.services.vr.enable) {
        services.monado = {
            enable = true;
            defaultRuntime = true;
        };
        systemd.user.services.monado.environment = {
            STEAMVR_LH_ENABLE = "1";
            XRT_COMPOSITOR_COMPUTE = "1";
        };
        programs.steam.extraCompatPackages = [
            pkgs.proton-ge-rtsp-bin
        ];
        home-manager.users.${cfg.userName} = {
            home.packages = [
                pkgs.xrizer
                pkgs.wlx-overlay-s
            ];
            home.file.".local/share/monado/hand-tracking-models".source = pkgs.fetchgit {
                url = "https://gitlab.freedesktop.org/monado/utilities/hand-tracking-models";
                sha256 = "sha256-x/X4HyyHdQUxn3CdMbWj5cfLvV7UyQe1D01H93UCk+M=";
                fetchLFS = true;
            };
            xdg.configFile = {
                "openxr/1/active_runtime.json".source =
                    "${config.services.monado.package}/share/openxr/1/openxr_monado.json";

                "openvr/openvrpaths.vrpath".text = builtins.toJSON {
                    config = [ "${config.home-manager.users.${cfg.userName}.xdg.dataHome}/Steam/config" ];
                    external_drivers = null;
                    jsonid = "vrpathreg";
                    log = [ "${config.home-manager.users.${cfg.userName}.xdg.dataHome}/Steam/logs" ];
                    runtime = [ "${pkgs.xrizer}/lib/xrizer" ];
                    version = 1;
                };
            };
        };
    };
}
