{
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = config.sidonia;
    theme = cfg.style.catppuccin;
    inherit (cfg.desktop.window) decoration;
    opts =
        with builtins.mapAttrs (n: v: "##${v}") theme.color;
        lib.concatStringsSep " " [
            "-nciwl '16 down' --single-instance --width-factor 0.33"
            "--border ${builtins.toString decoration.borderWidth} --border-radius ${builtins.toString decoration.rounding}"
            "--tb '${base}${decoration.opacity.hex}'"
            "--fb '${base}${decoration.opacity.hex}'"
            "--nb '${base}${decoration.opacity.hex}'"
            "--ab '${base}${decoration.opacity.hex}'"
            "--hb '${base}${decoration.opacity.hex}'"
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
