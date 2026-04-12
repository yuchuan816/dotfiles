#!/bin/zsh
# ~/.oh-my-zsh/custom/plugins/my-nas-commands/my-nas-commands.plugin.zsh

() {
    # 局部变量定义，函数执行完后自动注销
    local _MY_HOME_DIR="/home/tom"
    local _MY_NAS_DIR="${_MY_HOME_DIR}/code/nas"

    #######################################
    # 媒体文件操作
    #######################################
    alias ucp="zsh ${_MY_NAS_DIR}/utils/cp.zsh"
    alias ucd="source ${_MY_NAS_DIR}/utils/cd.zsh"

    #######################################
    # 系统操作
    #######################################
    alias rcp='rsync -avh --progress'
    alias off='echo -n "确定要关机吗? (Y/n): "; read -r ans; [[ -z "$ans" || "$ans" =~ ^[Yy]$ ]] && sudo shutdown now'

    #######################################
    # docker compose 快速操作
    #######################################
    alias dcctl="zsh ${_MY_NAS_DIR}/utils/dcctl.zsh"
}
