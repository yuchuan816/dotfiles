#!/bin/zsh
# ~/.oh-my-zsh/custom/plugins/my-custom-commands/my-custom-commands.plugin.zsh

() {
    # 系统标识抽象 (使用 readonly local 锁定，兼容版本更新)
    local -r _OS_PLATFORM="${OSTYPE%%[0-9]*}"

    is_linux() { [[ "$_OS_PLATFORM" == "linux-gnu"  ]]; }
    is_mac()   { [[ "$_OS_PLATFORM" == "darwin"  ]]; }
    is_wsl()   { grep -qi "microsoft" /proc/version 2>/dev/null; }
    is_nas()   { [[ "$(hostname)" == "nas-home" ]]; }
    is_nixos() { [[ -f /etc/NIXOS ]]; }

    #######################################
    # 代理
    #######################################
    local _PORT="7897"
    local _HOST_IP=""

    # 探测逻辑
    if is_linux && is_nas; then
        _HOST_IP="home.server"
        _PORT="20171"
    elif is_linux && is_wsl; then
        _HOST_IP=$(ip route | grep default | awk '{print $3}')
    else
        _HOST_IP="127.0.0.1"
    fi

    # 严格断路检查 (Fail-Fast)
    if [[ -z "$_HOST_IP" ]]; then
        echo "【中断】无法获取 HOST_IP！请检查网络或执行 'ip route' 确认路由表。"
        return 1
    fi

    # 导出全局变量供 Alias 使用
    export PROXY_HOST_IP="$_HOST_IP"
    export PROXY_PORT="$_PORT"

    # 定义 Alias
    alias setp='export https_proxy="http://${PROXY_HOST_IP}:${PROXY_PORT}"; \
                export http_proxy="http://${PROXY_HOST_IP}:${PROXY_PORT}"; \
                export all_proxy="socks5://${PROXY_HOST_IP}:${PROXY_PORT}"; \
                echo "代理开启 -> ${PROXY_HOST_IP}:${PROXY_PORT}"; \
                curl -I -s --connect-timeout 3 https://www.google.com > /dev/null && echo "✅ 网络连通正常" || echo "❌ 代理可能无法连接"'

    alias unsetp='unset https_proxy http_proxy all_proxy ALL_PROXY; echo "代理已关闭"'
    alias myip='curl -L ip.p3terx.com'

    #######################################
    # Mac Homebrew 镜像源修改
    #######################################
    if is_mac; then
        # Homebrew 镜像源
        export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
        export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
        export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
        export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
    fi

    #######################################
    # 同步远程配置
    #######################################
    update-configs() {
        if is_nixos; then
            echo "--------------------------------------------------"
            echo "【拒绝执行】检测到当前为 NixOS 环境"
            echo "原因：配置文件由 Home Manager 声明式管理，禁止手动覆盖。"
            echo "建议：请修改 ~/dotfiles 目录下的配置后执行 'nrs'。"
            echo "--------------------------------------------------"
            return 1
        fi

        echo '🚀 开始同步 macOS 配置...'
        
        # 1. 更新 Vim 配置
        echo '正在拉取 Vim 配置...'
        curl -fLo ~/.vimrc --create-dirs https://raw.githubusercontent.com/yuchuan816/dotfiles/refs/heads/master/.vimrc

        # 2. 更新本脚本自身
        echo '正在拉取 Zsh 插件自定义命令...'
        local tmp_file=$(mktemp)
        if curl -fLo "$tmp_file" https://raw.githubusercontent.com/yuchuan816/dotfiles/refs/heads/master/my-custom-commands.plugin.zsh; then
            mkdir -p ~/.oh-my-zsh/custom/plugins/my-custom-commands
            # 使用 \mv 避开别名检查
            \mv "$tmp_file" ~/.oh-my-zsh/custom/plugins/my-custom-commands/my-custom-commands.plugin.zsh
            echo '✅ 配置已更新！请执行: source ~/.zshrc'
        else
            echo '❌ 更新失败，请检查网络连接'
            rm -f "$tmp_file"
            return 1
        fi
    }

    alias upconf='update-configs'

    #######################################
    # SSH
    #######################################
    alias nas='ssh tom@home.server'
    alias router='ssh root@openwrt.lan'
}
