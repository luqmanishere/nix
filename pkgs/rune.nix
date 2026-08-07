{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go_1_26,
  luajit,
}:
(buildGoModule.override {go = go_1_26;}) rec {
  pname = "rune-mud";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "mmcdole";
    repo = "rune";
    rev = "v${version}";
    hash = "sha256-cD8YmO0NPeiSb4vuhwB6koBZYelynVQdvP6Fp5qn20g=";
  };

  vendorHash = "sha256-Jr+CWp47xaLO/HB84ti7ZJJu+TkTWp+FaRak7K8ZhcI=";

  modRoot = ".";
  subPackages = ["cmd/rune"];

  tags = ["luajit"];

  postPatch = ''
    substituteInPlace go.mod \
      --replace-fail "go 1.26.5" "go 1.26.4"

    substituteInPlace script/luajit/link_linux.go \
      --replace-fail "-I/usr/include/luajit-2.1" "-I${luajit}/include/luajit-2.1" \
      --replace-fail "-l:libluajit-5.1.a" "-L${luajit}/lib -l:libluajit-5.1.a"
  '';

  buildInputs = [
    luajit
  ];

  env.CGO_ENABLED = "1";

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
