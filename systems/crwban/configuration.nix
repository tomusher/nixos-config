{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./selfhosted.nix
    ./backup.nix
    ../../users/tom/nixos-user.nix
    inputs.vscode-server.nixosModule
    inputs.home-manager.nixosModule
  ];


  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
    };
    users.tom = {
      imports = [ ../../users/tom/remote.nix ../../users/tom/apps/email.nix ];
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = false;
  networking.interfaces.ens18.useDHCP = true;

  networking.firewall.enable = false;

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    keyMap = "uk";
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    podman
  ];

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  services.vscode-server.enable = true;

  fileSystems."/mnt/disk1" = {
    device = "192.168.0.104:/srv/nfs/disk1";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" "hard" "intr" "timeo=30" ];
  };
  fileSystems."/mnt/disk2" = {
    device = "192.168.0.104:/srv/nfs/disk2";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" "hard" "intr" "timeo=30" ];
  };
  fileSystems."/mnt/big" = {
    device = "192.168.0.120:/export/big";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" "hard" "intr" "timeo=30" ];
  };
}

