{
  perSystem =
    {
      lib,
      pkgs,
      self',
      config,
      inputs',
      ...
    }:
    {
      devShells.default = pkgs.mkShellNoCC {
        name = "dotfiles";
        meta.description = "Development shell for this configuration";

        shellHook = config.pre-commit.installationScript;

        # tell direnv to shut up
        DIRENV_LOG_FORMAT = "";

        packages =
          with pkgs;
          [
            git # flakes require git
            nixd # nix language server
            just # quick and easy task runner
            nodejs-slim # needed ags
            self'.formatter # nix formatter
            nix-output-monitor # get clean diff between generations
            inputs'.agenix.packages.agenix # secrets
            inputs'.deploy-rs.packages.deploy-rs # remote deployment
          ]
          ++ lib.optionals stdenv.isDarwin [ inputs'.darwin.packages.darwin-rebuild ];

        inputsFrom = [ config.treefmt.build.devShell ];
      };
    };
}
