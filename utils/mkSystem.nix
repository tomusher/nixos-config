config@{ nixpkgs, inputs, ... }:

with builtins;
nixpkgs.lib.nixosSystem {
  system = config.system;

  specialArgs = {
    inherit inputs;
    currentSystem = config.system;
    sshPubKey = config.sshPubKey;
  };

  modules = [
    ../systems/common.nix
    ../systems/${config.hostname}/configuration.nix
    inputs.home-manager.nixosModule
    inputs.agenix.nixosModule
    ({
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs;
        };
        users = builtins.mapAttrs
          (name: value: {
            imports = [ value.home-manager ];
          })
          config.users;
      };
    })
  ] ++ (map (key: getAttr "nixos" (getAttr key config.users)) (attrNames config.users));
}
