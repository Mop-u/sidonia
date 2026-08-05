{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:

lib.mkIf (config.programs.vesktop.enable && osConfig.sidonia.graphics.legacyGpu) {
  home.packages = [
    (osConfig.sidonia.lib.addDesktopFlags config.programs.vesktop.package "vesktop" [ "--disable-gpu" ])
  ];
}
