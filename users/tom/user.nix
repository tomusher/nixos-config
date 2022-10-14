{ config, pkgs, inputs, ... }:
{
  users.mutableUsers = false;
  users.users.tom = {
    isNormalUser = true;
    home = "/home/tom";
    extraGroups = [ "wheel" "video" "docker" ];
    shell = pkgs.zsh;
    hashedPassword = "$6$rjV32e5YWEGDfQXx$4vXTaldw.qJc4gED.dpRrnYRTKxsqriINORRJZFU2cdJkxQtEWjOpeq2sjEbJ1EeKngxnafEY2W2AB1hGBqrc.";
  };
}
