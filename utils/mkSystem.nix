let
  mkConfig = config: type: {
    system = config.system;

    specialArgs = {
      inputs = config.inputs;
      currentSystem = config.system;
      sshPubKey = config.sshPubKey;
      hostname = config.hostname;
    };

    modules = [
      ../systems/common.nix
      ../systems/${type}.nix
      ../systems/${config.hostname}/configuration.nix
    ];
  };
in {
  nixos = config@{ inputs, ... }:
    inputs.nixpkgs.lib.nixosSystem (mkConfig config "nixos");

  darwin = config@{ inputs, ... }:
    inputs.darwin.lib.darwinSystem (mkConfig config "darwin");
}
