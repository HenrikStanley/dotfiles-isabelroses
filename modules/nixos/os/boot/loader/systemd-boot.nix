{ config, lib, ... }:
let
  inherit (lib) mkDefault mkIf optionalAttrs;

  cfg = config.modules.system.boot;
in
{
  config = mkIf (cfg.loader == "systemd-boot") {
    boot.loader = {
      systemd-boot =
        {
          enable = mkDefault true;
          configurationLimit = null;
          consoleMode = mkDefault "max"; # the default is "keep"

          # Fix a security hole. See desc in nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
          editor = false;
        }
        // optionalAttrs cfg.memtest.enable {
          extraFiles."efi/memtest86plus/memtest.efi" = "${cfg.boot.memtest.package}/memtest.efi";
          extraEntries."memtest86plus.conf" = ''
            title MemTest86+
            efi   /efi/memtest86plus/memtest.efi
          '';
        };
    };
  };
}
