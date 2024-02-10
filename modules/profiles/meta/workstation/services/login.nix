{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.modules) system environment programs;
  inherit (lib) mkIf;
  sessionData = config.services.xserver.displayManager.sessionData.desktops;
  sessionPath = lib.concatStringsSep ":" [
    "${sessionData}/share/xsessions"
    "${sessionData}/share/wayland-sessions"
  ];
in {
  config = {
    # unlock GPG keyring on login
    security.pam.services = {
      login = {
        enableGnomeKeyring = true;
        gnupg = {
          enable = true;
          noAutostart = true;
          storeOnly = true;
        };
      };

      greetd = mkIf (environment.loginManager == "greetd") {
        gnupg.enable = true;
        enableGnomeKeyring = true;
      };
    };

    services = {
      xserver.displayManager.session = [
        {
          manage = "desktop";
          name = "hyprland";
          start = ''
            Hyprland
          '';
        }
      ];

      greetd = {
        enable = environment.loginManager == "greetd";
        vt = 2;
        restart = !system.autoLogin;
        settings = {
          # pick up desktop variant (i.e Hyprland) and username from environment module
          # this option is usually defined in host/<hostname>/system.nix
          initial_session = mkIf system.autoLogin {
            command = "${environment.desktop}";
            user = "${system.mainUser}";
          };

          default_session =
            if (!system.autoLogin)
            then {
              command = lib.concatStringsSep " " [
                (lib.getExe pkgs.greetd.tuigreet)
                "--time"
                "--remember"
                "--remember-user-session"
                "--asterisks"
                "--sessions '${sessionPath}'"
              ];
              user = "greeter";
            }
            else {
              command = "${environment.desktop}";
              user = "${system.mainUser}";
            };
        };
      };

      gnome = {
        glib-networking.enable = true;
        gnome-keyring.enable = true;
      };

      logind = {
        lidSwitch = "ignore";
        lidSwitchDocked = "ignore";
        lidSwitchExternalPower = "ignore";
        powerKey = "suspend-then-hibernate";
      };
    };
  };
}
