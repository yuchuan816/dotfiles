{ config, pkgs, ... }:

{
  home.username = "tom";
  home.homeDirectory = "/home/tom";
  home.stateVersion = "25.11"; 

  # --- 软件包安装 ---
  home.packages = with pkgs; [
    # 放置没有专门 programs 配置的工具
    htop
    tree
  ];

  # --- 基础程序管理 ---
  programs.home-manager.enable = true;

  # Git 配置
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Liu Yuchuan";
        email = "liuyuchuan816@live.com";
      };
      init.defaultBranch = "master";
      core.editor = "vim";
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  # Vim 配置
  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile ./.vimrc;
  };

  # --- Shell (Zsh) 配置 ---
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;

    # 插件管理
    plugins = [
      {
        name = "you-should-use";
        src = pkgs.zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
      {
        name = "my-custom-commands";
        src = ./.; 
        file = "my-custom-commands.plugin.zsh";
      }
    ];

    # 常用别名
    shellAliases = {
      # 快速应用 NixOS 配置的快捷命令
      nrs = "sudo nixos-rebuild switch --flake .#nixos";
      # 快速清理
      nclean = "sudo nix-collect-garbage -d";
    };

    # Oh-My-Zsh 配置
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
        "common-aliases"
        "colored-man-pages"
        "z"
      ];
    };
  };
}