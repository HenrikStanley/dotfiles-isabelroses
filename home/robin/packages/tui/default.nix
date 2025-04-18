{
  lib,
  pkgs,
  config,
  inputs',
  ...
}:
let
  inherit (lib.modules) mkIf;

  cfg = config.garden.programs;
in
{
  imports = [
    ./izrss.nix
    ./lazygit.nix
    ./neovim.nix
    ./yazi.nix
  ];

  config = mkIf cfg.tui.enable {
    garden.packages = {
      inherit (pkgs)
        # wishlist # fancy ssh
        glow # fancy markdown
        # fx # fancy jq
        gum # a nicer scripting
        ;

      inherit (inputs'.tgirlpkgs.packages) zzz; # code snippets in the cli
    };
  };
}
