{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go_1_26,
}:
(buildGoModule.override {go = go_1_26;}) rec {
  pname = "rune-mud";
  version = "0.6.0-unstable-2026-07-21";

  src = fetchFromGitHub {
    owner = "mmcdole";
    repo = "rune";
    rev = "8c40c152f2ae3c46a03e9e536f96c81997d3a2f9";
    hash = "sha256-8CZo12Zqj7V1be75COlp9LybHGiTn4pwUJUHHS097CI=";
  };

  vendorHash = "sha256-gYU8W2urhkt0HMjGJxKYHGwLCYzRSGFXnerSd2Y+eNQ=";

  modRoot = ".";
  subPackages = ["cmd/rune"];

  postPatch = ''
    substituteInPlace go.mod \
      --replace-fail "go 1.26.5" "go 1.26.4"
  '';

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mmcdole/rune/version.Number=${version}"
  ];

  meta = {
    description = "Modern terminal MUD client";
    homepage = "https://github.com/mmcdole/rune";
    license = lib.licenses.mit;
    mainProgram = "rune";
  };
}
