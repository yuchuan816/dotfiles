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

  # 存储优化
  nix.settings = {
    auto-optimise-store = true; # 自动优化存储（去重相同文件，节省硬盘空间）
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d"; # 自动删除 7 天前的生成版本
  };

  # 用户定义 (仅定义身份)
  users.users.tom = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  # 系统层开启 zsh 支持
  programs.zsh.enable = true;

  fonts.packages = with pkgs; [
    # 安装 Nerd Fonts 补丁过的字体，支持终端图标
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
    # 中文字体
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
      "https://cache.nixos.org/"
    ];
  };

  system.stateVersion = "25.11";
}