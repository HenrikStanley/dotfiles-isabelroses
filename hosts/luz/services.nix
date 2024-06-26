{
  modules.services = {
    vaultwarden.enable = true;
    isabelroses-website.enable = true;
    blahaj.enable = true;
    vikunja.enable = true;
    kanidm.enable = true;
    mailserver.enable = true;

    networking = {
      nginx.enable = true;
      cloudflared.enable = false;
      headscale.enable = false;
    };

    dev = {
      atuin.enable = true;
      forgejo.enable = true;
      wakapi.enable = true;
      vscode-server.enable = false;
      plausible.enable = false;
    };

    media = {
      akkoma.enable = true;
      matrix.enable = true;
      nextcloud.enable = true;
    };

    monitoring = {
      grafana.enable = true;
      prometheus.enable = true;
      loki.enable = false;
      uptime-kuma.enable = true;
    };

    database = {
      influxdb.enable = false;
      mysql.enable = false;
      mongodb.enable = false;
      postgresql.enable = true;
      redis.enable = true;
    };
  };
}
