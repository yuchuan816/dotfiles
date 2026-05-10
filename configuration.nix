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

  # 用户定义
  users.users.tom = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  # 系统层开启 zsh 支持
  programs.zsh.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    wqy_zenhei
  ];

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
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

    trusted-users = [ "root" "@wheel" ];

    # 自动优化存储（去重相同文件）
    auto-optimise-store = true;
  };

  # 自动删除 7 天前的生成版本
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "25.11";
}