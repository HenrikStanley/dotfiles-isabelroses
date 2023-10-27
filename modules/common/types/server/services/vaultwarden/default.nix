{
  config,
  lib,
  ...
}: let
  inherit (config.networking) domain;
  cfg = config.modules.services.vaultwarden;
in {
  config = lib.mkIf cfg.enable {
    # this forces the system to create backup folder
    systemd.services = {
      vaultwarden.after = ["sops-nix.service"];
      backup-vaultwarden.serviceConfig = {
        User = "root";
        Group = "root";
      };
    };

    services.vaultwarden = {
      enable = true;
      environmentFile = config.sops.secrets.vaultwarden-env.path;
      backupDir = "/srv/storage/vaultwarden/backup";
      config = {
        DOMAIN = "https://vault.${domain}";
        SIGNUPS_ALLOWED = false;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        extendedLogging = true;
        invitationsAllowed = true;
        useSyslog = true;
        logLevel = "warn";
        showPasswordHint = false;
        signupsAllowed = false;
        signupsDomainsWhitelist = "${domain}";
        signupsVerify = true;
        smtpAuthMechanism = "Login";
        smtpFrom = "vaultwarden@${domain}";
        smtpFromName = "Isabelroses's Vaultwarden Service";
        smtpHost = "mail.${domain}";
        smtpPort = 465;
        smtpSecurity = "force_tls";
        dataDir = "/srv/storage/vaultwarden";
      };
    };
  };
}