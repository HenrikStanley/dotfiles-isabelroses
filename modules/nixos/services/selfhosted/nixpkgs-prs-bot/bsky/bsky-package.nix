# TODO: https://github.com/NixOS/nixpkgs/pull/390182
{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
  nix-update-script,
}:
let
  version = "0.0.73";
in
buildGoModule {
  pname = "bsky-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "bsky";
    tag = "v${version}";
    hash = "sha256-GTuF/ZbZ84tTcbjp8eXKdpUGCsOkg2rxEcslKTsgpu4=";
  };

  vendorHash = "sha256-dLhrPHjhEHEJOokkjll1Z+zhDlBXuhlJJBtCFXfhyws=";

  buildInputs = [
    libpcap
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A cli application for bluesky social";
    homepage = "https://github.com/mattn/bsky";
    changelog = "https://github.com/mattn/bsky/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "bsky";
  };
}
