{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # 核心引导与硬件
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  networking.hostName = "nixos";

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  # 系统服务
  services.openssh.enable = true;
  services.vscode-server.enable = true;

  # 用户定义 (仅定义身份)
  users.users.tom = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh; # 登录 Shell
  };

  # 系统层开启 zsh 支持
  programs.zsh.enable = true;

  # 系统级软件 (仅放 root 也会用到的工具)
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
  ];

  # Nix 策略
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
  };

  system.stateVersion = "25.11";
}