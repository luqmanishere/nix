{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go_1_26,
  luajit,
}:
(buildGoModule.override {go = go_1_26;}) rec {
  pname = "rune-mud";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "mmcdole";
    repo = "rune";
    rev = "v${version}";
    hash = "sha256-+ZbQZq1ba7Zj4AM42v0RzXAxTsuL852sYQK1FKbjddI=";
  };

  vendorHash = "sha256-q1TUvSEtvBdihZCyW1yD4rL4I4Bc27xpj/CT5UB+HHk=";

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
