{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-ge-custom";
  version = "11-11";

  src = fetchzip {
    url = "https://github.com/GloriousEggroll/${finalAttrs.pname}/releases/download/GE-Proton${finalAttrs.version}/GE-Proton${finalAttrs.version}.tar.gz";
    hash = "sha256-3tVgf83IkteFtVo/bHd4yG1xCtPeuW8FXaTrHOLjvKQ=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  outputs = [
    "out"
    "steamcompattool"
  ];

  installPhase = ''
    runHook preInstall

    # Make it impossible to add to an environment. Use programs.steam.extraCompatPackages instead.
    echo "ge-proton should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

    # Create steamcompattool output and symlink everything, then copy compatibilitytool.vdf for modification
    mkdir $steamcompattool
    ln -s $src/* $steamcompattool
    rm $steamcompattool/compatibilitytool.vdf
    cp $src/compatibilitytool.vdf $steamcompattool

    runHook postInstall
  '';

  meta = with lib; {
    description = ''
      GE Proton compatibility layer.

      (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
    '';
    homepage = "https://github.com/GloriousEggroll/proton-ge-custom/";
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
    maintainers = [];
    sourceProvenance = [sourceTypes.binaryNativeCode];
  };
})
