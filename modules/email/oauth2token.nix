{ lib
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "oauth2token";
  version = "0.0.3";
  format = "setuptools";

  src = python3Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-3wJHPYP74rTdqAfVKZ7LrzwP4tCeV+VRasoqs1uw/vg=";
  };

  propagatedBuildInputs = with python3Packages; [
    google-auth-oauthlib
    pyxdg
  ];
}