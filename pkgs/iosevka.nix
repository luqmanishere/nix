{
  stdenv,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  darwin,
  remarshal,
  ttfautohint-nox,
  # Custom font set options.
  # See https://typeof.net/Iosevka/customizer
  # Can be a raw TOML string, or a Nix attrset.
  # Ex:
  # privateBuildPlan = ''
  #   [buildPlans.iosevka-custom]
  #   family = "Iosevka Custom"
  #   spacing = "normal"
  #   serifs = "sans"
  #
  #   [buildPlans.iosevka-custom.variants.design]
  #   capital-j = "serifless"
  #
  #   [buildPlans.iosevka-custom.variants.italic]
  #   i = "tailed"
  # '';
  # Or:
  # privateBuildPlan = {
  #   family = "Iosevka Custom";
  #   spacing = "normal";
  #   serifs = "sans";
  #
  #   variants = {
  #     design.capital-j = "serifless";
  #     italic.i = "tailed";
  #   };
  # }
  privateBuildPlan ? null,
  # Extra parameters. Can be used for ligature mapping.
  # It must be a raw TOML string.
  # Ex:
  # extraParameters = ''
  #   [[iosevka.compLig]]
  #   unicode = 57808 # 0xe1d0
  #   featureTag = 'XHS0'
  #   sequence = "+>"
  # '';
  extraParameters ? null,
  # Custom font set name. Required if any custom settings above.
  set ? null,
}:
assert (privateBuildPlan != null) -> set != null;
assert (extraParameters != null) -> set != null;
  buildNpmPackage rec {
    pname =
      if set != null
      then "iosevka-${set}"
      else "iosevka";
    version = "26.3.2";

    src = fetchFromGitHub {
      owner = "be5invis";
      repo = "iosevka";
      rev = "v${version}";
      hash = "sha256-w+D3ehgIB/qzvD5pc4Tr5Ct6EIJuzdVaBhKPLFf9LZA=";
    };

    npmDepsHash = "sha256-2gf61TtqiTxxeFy0UEMf/EJQotT+dLuHhhLVVJztu08=";

    nativeBuildInputs =
      [
        remarshal
        ttfautohint-nox
      ]
      ++ lib.optionals stdenv.isDarwin [
        # libtool
        darwin.cctools
      ];

    buildPlan =
      if builtins.isAttrs privateBuildPlan
      then builtins.toJSON {buildPlans.${pname} = privateBuildPlan;}
      else privateBuildPlan;

    inherit extraParameters;
    passAsFile =
      ["extraParameters"]
      ++ lib.optionals
      (!(builtins.isString privateBuildPlan
        && lib.hasPrefix builtins.storeDir privateBuildPlan)) ["buildPlan"];

    npmBuildFlags = [
      "--max-old-space-size=1000"
    ];

    NODE_OPTIONS = "--max-old-space-size=1000";

    configurePhase = ''
      runHook preConfigure
      ${lib.optionalString (builtins.isAttrs privateBuildPlan) ''
        remarshal -i "$buildPlanPath" -o private-build-plans.toml -if json -of toml
      ''}
      ${lib.optionalString (builtins.isString privateBuildPlan
        && (!lib.hasPrefix builtins.storeDir privateBuildPlan)) ''
        cp "$buildPlanPath" private-build-plans.toml
      ''}
      ${lib.optionalString (builtins.isString privateBuildPlan
        && (lib.hasPrefix builtins.storeDir privateBuildPlan)) ''
        cp "$buildPlan" private-build-plans.toml
      ''}
      ${lib.optionalString (extraParameters != null) ''
        echo -e "\n" >> params/parameters.toml
        cat "$extraParametersPath" >> params/parameters.toml
      ''}
      runHook postConfigure
    '';

    # npm run build --no-update-notifier --max_executable_size=4096 --max-old-space-size=1000 -- --max-old-space-size=1000 --jCmd=4 --max_executable_size=4096 --verbose=9 ttf::$pname
    # npm run build --no-update-notifier --  --verbose=9 ttf::$pname
    buildPhase = ''
      export NODE_OPTIONS="--max-old-space-size=1000"
      export HOME=$TMPDIR
      runHook preBuild
      npm run build --no-update-notifier --  --verbose=9 ttf::$pname
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      fontdir="$out/share/fonts/truetype"
      install -d "$fontdir"
      install "dist/$pname/ttf"/* "$fontdir"
      runHook postInstall
    '';

    enableParallelBuilding = true;

    meta = with lib; {
      homepage = "https://typeof.net/Iosevka/";
      downloadPage = "https://github.com/be5invis/Iosevka/releases";
      description = "Versatile typeface for code, from code.";
      longDescription = ''
        Iosevka is an open-source, sans-serif + slab-serif, monospace +
        quasi‑proportional typeface family, designed for writing code, using in
        terminals, and preparing technical documents.
      '';
      license = licenses.ofl;
      platforms = platforms.all;
      maintainers = with maintainers; [
        cstrahan
        jfrankenau
        ttuegel
        babariviere
        rileyinman
        AluisioASG
        lunik1
      ];
    };
  }
