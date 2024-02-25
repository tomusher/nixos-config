{ config, pkgs, inputs, ... }:
let
  secrets = import ../../secrets/secrets.nix;
in {
  imports = [
    ./hardware-configuration.nix
    ./selfhosted.nix
    #./backup.nix
    ../../users/tom/nixos-user.nix
    ../../modules/autorestic.nix
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
      imports = [
        ../../users/tom/remote.nix
        #../../users/tom/apps/email.nix
      ];
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

  networking.useDHCP = false;
  networking.interfaces.ens18.useDHCP = true;

  networking.hostName = "crwban";
  networking.firewall.enable = false;

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    keyMap = "uk";
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    podman
  ];

  programs.ssh.startAgent = true;
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  services.vscode-server.enable = true;
  services.fstrim.enable = true;
  services.cloudflared = {
    enable = true;
    tunnels = {
      "7e173587-e69f-4fd7-bbee-5604042f755e" = {
        credentialsFile = "${secrets.cloudflaredSecrets}";
        default = "http_status:404";
      };
    };
  };

  environment.etc = {
    "autorestic/backup_excludes".source = ./backup_excludes;
  };

  services.autorestic = {
    enable = true;
    settings = {
      version = 2;
      global = {
        forget = {
          keep-last = 24;
          keep-hourly = 48;
          keep-daily = 180;
          keep-weekly = 52;
          keep-monthly = 24;
          keep-yearly = 100;
          keep-within = "14d";
        };
      };

      locations = {
        app_configs = {
          from = "/srv/";
          to = "backblaze";
          forget = "prune";
          cron = "0 * * * *";
          hooks = {
            before = [ "docker exec --user postgres postgres pg_dumpall > /tmp/postgres.sql" ];
          };
          options = {
            backup = {
              exclude-file = "/etc/autorestic/backup_excludes";
            };
          };
        };
      };

      backends = {
        backblaze = {
          type = "b2";
          path = "tusher-backup-restic:server";
          key = secrets.restic_backups_password;
          env = {
            B2_ACCOUNT_ID = secrets.backblaze_b2_account_id;
            B2_ACCOUNT_KEY = secrets.backblaze_b2_account_key;
          };
        };
      };
    };
  };

  fileSystems."/mnt/morfil/media" = {
    device = "192.168.0.145:/mnt/data/media";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" "hard" "timeo=30" ];
  };
  fileSystems."/mnt/morfil/files" = {
    device = "192.168.0.145:/mnt/data/files";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" "hard" "timeo=30" ];
  };
  fileSystems."/mnt/big" = {
    device = "/dev/disk/by-uuid/084ddf6a-5f27-4a7b-84d2-954c11ec0616";
    fsType = "ext4";
  };
}

