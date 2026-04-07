#!/bin/zsh
# ~/.oh-my-zsh/custom/plugins/my-custom-commands/my-custom-commands.plugin.zsh

() {
    # 系统标识抽象 (使用 readonly local 锁定，兼容版本更新)
    local -r _OS_PLATFORM="${OSTYPE%%[0-9]*}"
    local -r _MAC_TYPE="darwin"
    local -r _LINUX_TYPE="linux-gnu"
    
    #######################################
    # 代理
    #######################################
    local -r _PORT="7897"
    local _HOST_IP=""

    # 核心探测逻辑
    if [[ "$_OS_PLATFORM" == "$_MAC_TYPE" ]]; then
        _HOST_IP="127.0.0.1"
    elif [[ "$_OS_PLATFORM" == "$_LINUX_TYPE" ]]; then
        # 仅通过 ip route 获取
        _HOST_IP=$(ip route | grep default | awk '{print $3}')
    else
        echo "【错误】未识别的操作系统类型: $OSTYPE"
        return 1
    fi

    # 严格断路检查 (Fail-Fast)
    if [[ -z "$_HOST_IP" ]]; then
        echo "【中断】无法获取 HOST_IP！请检查网络或执行 'ip route' 确认路由表。"
        return 1
    fi

    # 导出全局变量供 Alias 使用
    export PROXY_HOST_IP="$_HOST_IP"

    # 定义 Alias
    alias setp="export https_proxy=\"http://\$PROXY_HOST_IP:$_PORT\"; \
                export http_proxy=\"http://\$PROXY_HOST_IP:$_PORT\"; \
                export all_proxy=\"socks5://\$PROXY_HOST_IP:$_PORT\"; \
                echo \"代理开启 -> \$PROXY_HOST_IP:$_PORT\"; \
                curl -I https://www.google.com --connect-timeout 2"

    alias unsetp='unset https_proxy http_proxy all_proxy ALL_PROXY; echo "代理已关闭"'
    alias myip='curl -L ip.p3terx.com'

    #######################################
    # Mac Homebrew 镜像源修改
    #######################################
    if [[ "$_OS_PLATFORM" == "$_MAC_TYPE" ]]; then
        # Homebrew 镜像源
        export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
        export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
        export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
        export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
    fi

    #######################################
    # 同步远程配置
    #######################################
    alias update-configs=" \
        echo '正在拉取 Vim 配置...'; \
        curl -fLo ~/.vimrc \
            https://raw.githubusercontent.com/yuchuan816/dotfiles/refs/heads/master/.vimrc; \
        \
        echo '正在拉取 Zsh 插件自定义命令...'; \
        mkdir -p ~/.oh-my-zsh/custom/plugins/my-custom-commands; \
        curl -fLo ~/.oh-my-zsh/custom/plugins/my-custom-commands/my-custom-commands.plugin.zsh \
            https://raw.githubusercontent.com/yuchuan816/dotfiles/refs/heads/master/my-custom-commands.plugin.zsh; \
        \
        echo '✅ 所有配置已更新！'; \
    "

    #######################################
    # SSH
    #######################################
    alias nas='ssh tom@home.server'
    alias router='ssh root@openwrt.lan'
}
