{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "s6-overlay";
  version = "3.0.0.2";

  src = fetchFromGitHub {
    owner = "just-containers";
    repo = "s6-overlay";
    rev = "v${version}";
    sha256 = lib.fakeSha256;
  };

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    runHook preBuild

    cp -r $src $out

    runHook postBuild
  '';
}
