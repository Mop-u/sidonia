{
    osConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    cfg = osConfig.sidonia;
    sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
    inherit (osConfig.programs.gpu-screen-recorder) enable;
in
lib.mkIf (cfg.desktop.enable && (cfg.desktop.shell == "noctalia-legacy")) {
    # https://github.com/noctalia-dev/noctalia-plugins/tree/main/screen-recorder
    programs.noctalia-shell = {
        plugins.states.screen-recorder = {
            enabled = lib.mkDefault enable;
            inherit sourceUrl;
        };
        pluginSettings.screen-recorder = {
            hideInactive = false;
            iconColor = "none";
            directory = "${config.home.homeDirectory}/Videos";
            filenamePattern = "recording_yyyyMMdd_HHmmss";
            frameRate = "custom";
            customFrameRate = "60";
            audioCodec = "opus";
            videoCodec = "h264";
            quality = "very_high";
            colorRange = "limited";
            showCursor = true;
            copyToClipboard = false;
            audioSource = "default_output";
            videoSource = "portal";
            resolution = "original";
            restorePortalSession = false;
            replayEnabled = false;
            replayDuration = "custom";
            customReplayDuration = "30";
            replayStorage = "ram";
        };
    };
    home.packages = lib.optional enable osConfig.programs.gpu-screen-recorder.package;
}
