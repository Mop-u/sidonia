{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
    inherit (cfg) window;
    opts =
        with builtins.mapAttrs (n: v: "##${v.hex}") cfg.style.catppuccin.color;
        lib.concatStringsSep " " [
            "-nciwl '16 down' --single-instance --width-factor 0.33"
            "--border ${builtins.toString window.borderSize} --border-radius ${builtins.toString window.rounding}"
            "--tb '${base}${window.opacity.hex}'"
            "--fb '${base}${window.opacity.hex}'"
            "--nb '${base}${window.opacity.hex}'"
            "--ab '${base}${window.opacity.hex}'"
            "--hb '${base}${window.opacity.hex}'"
            "--tf '${accent}'"
            "--ff '${text}'"
            "--nf '${text}'"
            "--af '${text}'"
            "--hf '${accent}'"
            "--bdr '${accent}'"
            "--fn monospace"
        ];
in
lib.mkIf (cfg.desktop.enable) {
    home-manager.users.${cfg.userName}.programs.bemenu.enable = true;
    sidonia.desktop.keybinds = [
        {
            name = "Bemenu";
            mod = [ "super" ];
            key = "o";
            exec = "$(bemenu-run --no-exec ${opts})";
        }
    ]
    ++ (lib.optional config.hardware.nvidia.prime.offload.enableOffloadCmd {
        mod = [
            "super"
            "shift"
        ];
        key = "o";
        exec = "nvidia-offload $(LIBVA_DRIVER_NAME=nvidia VDPAU_NAME=nvidia bemenu-run --no-exec ${opts})";
    });
}
