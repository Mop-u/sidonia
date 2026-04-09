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
lib.mkIf (cfg.desktop.enable && (cfg.desktop.shell == "noctalia")) {
    programs.noctalia-shell.settings.audio = builtins.mapAttrs (n: v: lib.mkDefault v) {
        volumeStep = 5;
        volumeOverdrive = false;
        spectrumFrameRate = 30;
        spectrumMirrored = true;
        volumeFeedbackSoundFile = "";
        visualizerType = "linear";
        mprisBlacklist = [ ];
        preferredPlayer = "";
        volumeFeedback = false;
    };
}
