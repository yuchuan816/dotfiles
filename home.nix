{ config, pkgs, ... }:

{
  home.username = "tom";
  home.homeDirectory = "/home/tom";
  home.stateVersion = "25.11"; # 保持与系统版本一致
  home.packages = with pkgs; [
    zsh-you-should-use
  ];

  # home-manager
  programs.home-manager.enable = true;

  # Vim
  programs.vim = {
    enable = true;
    # 引用当前目录下的 .vimrc 文件
    extraConfig = builtins.readFile ./.vimrc;
  };

  # Zsh
  programs.zsh = {
    enable = true;

    plugins = [
      # 1. 来自 Nixpkgs 仓库的插件
      {
        name = "you-should-use";
        src = pkgs.zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
      # 2. 来自你本地文件的插件
      {
        name = "my-custom-commands";
        src = ./.; # 告诉 Nix 源文件在当前目录
        file = "my-custom-commands.plugin.zsh"; # 指定具体的脚本名
      }
    ];

    oh-my-zsh = {
      enable = true;

      plugins = [
        "git"
        "sudo"
        "common-aliases"
        "colored-man-pages"
        "z"
      ];
      theme = "robbyrussell";
    };
  };

  # Git
  programs.git = {
    enable = true;
    # Home Manager 的标准选项
    userName = "Liu Yuchuan";
    userEmail = "liuyuchuan816@live.com";

    extraConfig = {
      init = {
        defaultBranch = "master";
      };
      core = { editor = "vim"; };
    };
  };
}