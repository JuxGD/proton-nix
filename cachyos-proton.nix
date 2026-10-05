{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-cachyos";
  version = "11.0-20261005-slr";

  src = fetchzip {
    url = "https://github.com/CachyOS/${finalAttrs.pname}/releases/download/cachyos-${finalAttrs.version}/proton-cachyos-${finalAttrs.version}-x86_64_v3.tar.xz";
    hash = "sha256-LlAnK4fAyLrWF+Z0L9Ft4kwfoSB+g+0o9XNvKlOSZXg=";
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
    echo "cachyos-proton should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

    # Create steamcompattool output and symlink everything, then copy compatibilitytool.vdf for modification
    mkdir $steamcompattool
    ln -s $src/* $steamcompattool
    rm $steamcompattool/compatibilitytool.vdf
    cp $src/compatibilitytool.vdf $steamcompattool

    runHook postInstall
  '';

  meta = with lib; {
    description = ''
      CachyOS Proton compatibility layer.

      (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
    '';
    homepage = "https://github.com/CachyOS/proton-cachyos/";
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
    maintainers = [];
    sourceProvenance = [sourceTypes.binaryNativeCode];
  };
})
