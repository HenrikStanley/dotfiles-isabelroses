{
  lib,
  pkgs,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.modules.programs.gui.fileManagers.dolphin.enable {
    home.packages = with pkgs; [
      libsForQt5.dolphin
    ];
  };
}
