{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/vmware-guest.nix
    ../../users/tom/nixos-user.nix
    inputs.home-manager.nixosModule
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
    };
    users.tom = {
      imports = [../../users/tom/guest-vm.nix]
    }
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnsupportedSystem = true;

  hardware.video.hidpi.enable = true;

  networking.useDHCP = false;
  networking.interfaces.ens160.useDHCP = true;

  security.sudo.wheelNeedsPassword = false;

#  programs.sway.enable = true;

  console = {
    keyMap = "uk";
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  services.xserver = {
    enable = true;
    layout = "gb";
    dpi = 220;

    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "scale";
    };

    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;

      sessionCommands = "${pkgs.xorg.xset}/bin/xset r rate 200 40";
    };

    resolutions = [{ x = 3024; y = 1964; }];

    windowManager = {
      i3.enable = true;
    };
  };

  services.gnome.gnome-keyring.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];

  fonts.fonts = with pkgs; [
    fira-code
    font-awesome_5
  ];

  services.openssh.enable = true;

  virtualisation.vmware.guest.enable = true;
  virtualisation.docker.enable = true;

  boot.blacklistedKernelModules = [
    "vsock_loopback"
    "vmw_vsock_virtio_transport_common"
  ];

  fileSystems."/host" = {
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    device = ".host:/tom";
    options = [
      "umask=22"
      "uid=1000"
      "gid=1000"
      "allow_other"
      "auto_unmount"
      "defaults"
    ];
  };

  nixpkgs.overlays = lib.singleton (self: super: {
    }); 

}

