{ pkgs
, lib
, python3Packages
}:

python3Packages.buildPythonPackage rec {
  pname = "google-auth-oauthlib";
  version = "0.5.2";
  format = "setuptools";

  src = python3Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-1emKcSAzMGmfkqJrwIhHqS6MOxuNgqAh8a80Fk2xQ64=";
  };

  propagatedBuildInputs = with python3Packages; [
    google-auth
    requests-oauthlib
  ];

  nativeCheckInputs = with python3Packages; [
    click
    mock
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Google Authentication Library: oauthlib integration";
    homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python-oauthlib";
    license = licenses.asl20;
    maintainers = with maintainers; [ terlar ];
  };
}
