{ lib, config, ... }:
let
  inherit (lib)
    mkIf
    template
    mkSecret
    mkServiceOption
    ;

  rdomain = config.networking.domain;
  cfg = config.modules.services.vikunja;
in
{
  options.modules.services.vikunja = mkServiceOption "vikunja" {
    domain = "todo.${rdomain}";
    port = 3456;
  };

  config = mkIf cfg.enable {
    age.secrets.vikunja-env = mkSecret {
      file = "vikunja-env";
      owner = "vikunja";
      group = "vikunja";
    };

    modules.services = {
      networking.nginx.enable = true;
      database = {
        redis.enable = true;
        postgresql.enable = true;
      };
    };

    services = {
      vikunja = {
        enable = true;
        inherit (cfg) port;
        frontendHostname = cfg.domain;
        frontendScheme = "https";

        environmentFiles = [ config.age.secrets.vikunja-env.path ];

        database = {
          type = "postgres";
          host = "/run/postgresql";
          user = "vikunja";
          database = "vikunja";
        };

        settings = {
          service.enableregistration = false;

          defaultsettings = {
            avatar_provider = "gravatar";
            week_start = 1; # monday
          };

          mailer = {
            enabled = true;
            host = config.modules.services.mailserver.domain;
            port = 465;
            forcessl = true;

            authtype = "login";
            fromemail = "noreply@${rdomain}";
            username = "noreply@${rdomain}";
          };

          openid = {
            enabled = true;
            redirecturl = "https://${cfg.domain}/auth/openid/";
            providers =
              let
                sso = config.modules.services.kanidm.domain;
              in
              [
                {
                  name = "Isabel's SSO";
                  authurl = "https://${sso}/oauth2/openid/vikunja/";
                  logouturl = "https://${sso}/logout";
                  clientid = "vikunja";
                }
              ];
          };

          # redis
          # redis = {
          #   enabled = true;
          #   host = "/run/redis-vikunja/redis.sock";
          #   db = 0;
          # };
        };
      };

      nginx.virtualHosts.${cfg.domain} = {
        locations."/".proxyPass = "http://${cfg.host}:${toString cfg.port}";
      } // template.ssl rdomain;
    };

    users = {
      groups.vikunja = { };

      users."vikunja" = {
        group = "vikunja";
        createHome = false;
        isSystemUser = true;
      };
    };
  };
}
