# dotfiles
My personal development environment configurations.

```
# 更新 Flake
nix flake update

# 构建系统
sudo nixos-rebuild switch --flake .#nixos

# 生成配置
sudo nixos-generate-config --dir ./temp_config
```
