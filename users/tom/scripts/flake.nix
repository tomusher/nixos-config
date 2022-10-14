{
  description = "flake for running utility scripts";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, poetry2nix }:
 
  let 
    supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    pkgs = nixpkgs.legacyPackages.aarch64-linux;
    env = pkgs.poetry2nix.mkPoetryEnv {
      projectDir = ./.;
    };
  in
  {
    defaultPackage = forAllSystems (system: env);
    devShell = forAllSystems (system:
      (nixpkgsFor.${system}).mkShell {
        buildInputs = with (nixpkgsFor.${system}); [ python3 poetry env ];
      }
    );

  };
}
