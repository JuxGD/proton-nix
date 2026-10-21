{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dwproton";
  version = "11.0-15";

  src = fetchzip {
    url = "https://dawn.wine/dawn-winery/${finalAttrs.pname}/releases/download/dwproton-${finalAttrs.version}/dwproton-${finalAttrs.version}-x86_64.tar.xz";
    hash = "sha256-vF5O5sR1/zr1+06SraznN4u8eRtp47bVYxj0ntCZIwQ=";
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
    echo "dw-proton should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

    # Create steamcompattool output and symlink everything, then copy compatibilitytool.vdf for modification
    mkdir $steamcompattool
    ln -s $src/* $steamcompattool
    rm $steamcompattool/compatibilitytool.vdf
    cp $src/compatibilitytool.vdf $steamcompattool

    runHook postInstall
  '';

  meta = with lib; {
    description = ''
      DW-Proton compatibility layer.

      (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
    '';
    homepage = "https://dawn.wine/";
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
    maintainers = [];
    sourceProvenance = [sourceTypes.binaryNativeCode];
  };
})
