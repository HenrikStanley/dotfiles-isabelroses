{
  osConfig,
  lib,
  pkgs,
  ...
}:
with lib; let
  programs = osConfig.modules.programs;
in {
  config = mkIf (programs.cli.enable) {
    home.packages = with pkgs; [
      # CLI packages from nixpkgs
      unzip
      ripgrep
      rsync
      fd
      jq
      dconf
      nitch
      exa
      nur.repos.bella.bellado
    ];
  };
}