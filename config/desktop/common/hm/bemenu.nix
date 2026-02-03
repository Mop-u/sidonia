{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
in
lib.mkIf (cfg.desktop.enable) {
    programs.bemenu = {
        enable = true;
        settings =
            with builtins.mapAttrs (n: v: "##${v}") config.catppuccin.lib.color;
            let
                inherit (cfg.desktop.window) decoration;
                background = base + decoration.opacity.hex;
            in
            {
                no-exec = true;
                prompt = "open";
                ignorecase = true;
                list = true;
                wrap = true;
                center = true;
                no-overlap = true;
                single-instance = true;
                width-factor = 0.33;
                border = decoration.borderWidth;
                border-radius = decoration.rounding;
                tb = background;
                fb = background;
                nb = background;
                ab = background;
                hb = background;
                tf = accent;
                ff = text;
                nf = text;
                af = text;
                hf = accent;
                bdr = accent;
                fn = "monospace";
            };
    };
    wayland.desktopManager.sidonia.keybinds = [
        {
            name = "Bemenu";
            mod = [ "super" ];
            key = "o";
            exec = "$(bemenu-run '16 down')";
        }
    ]
    ++ (lib.optional osConfig.hardware.nvidia.prime.offload.enableOffloadCmd {
        mod = [
            "super"
            "shift"
        ];
        key = "o";
        exec = "nvidia-offload $(LIBVA_DRIVER_NAME=nvidia VDPAU_NAME=nvidia bemenu-run '16 down')";
    });
}
