{ lib, pkgs, ... }:
{
  garden.packages = lib.modules.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    inherit (pkgs)
      libwebp # WebP image format library
      m-cli # A macOS cli tool to manage macOS - a true swis army knife
      ;
  };
}
