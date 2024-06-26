{
  lib,
  pkgs,
  config,
  ...
}:
{
  programs = {
    # home-manager is so strange and needs these declared multiple times
    fish.enable = true;

    # type "fuck" to fix the last command that made you go "fuck"
    thefuck.enable = true;

    # help manage android devices via command line
    adb.enable = true;

    # show network usage
    bandwhich.enable = true;

    # enable direnv integration
    direnv = {
      enable = true;
      silent = true;
      # faster, persistent implementation of use_nix and use_flake
      nix-direnv = {
        enable = true;
        package = pkgs.nix-direnv.override { nix = config.nix.package; };
      };

      # enable loading direnv in nix-shell nix shell or nix develop
      loadInNixShell = true;
    };
  };

  # determine which version of wine to use
  environment.systemPackages =
    with pkgs;
    let
      winePackage =
        if (lib.isWayland config) then wineWowPackages.waylandFull else wineWowPackages.stableFull;
    in
    lib.mkIf config.modules.programs.agnostic.wine.enable [ winePackage ];
}
