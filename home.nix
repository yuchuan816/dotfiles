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
      rebase.autoStash = true; # 推荐加上，pull --rebase 时更无感
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