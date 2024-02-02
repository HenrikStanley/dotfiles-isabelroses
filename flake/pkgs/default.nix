_: {
  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    packages = {
      lutgen-rs = pkgs.callPackage ./lutgen-rs.nix {};
      patched-gjs = pkgs.callPackage ./patched-gjs.nix {};
      plymouth-theme-catppuccin = pkgs.callPackage ./plymouth-theme-catppuccin.nix {};
      headscale-ui = pkgs.callPackage ./headscale-ui.nix {};

      bellado = inputs'.bellado.packages.default;
      isabelroses-website = inputs'.isabelroses-website.packages.default;
      catppuccinifier-cli = inputs'.catppuccinifier.packages.cli;
    };
  };
}
