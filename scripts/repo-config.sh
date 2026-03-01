#!/bin/bash
# APT 仓库共享配置
# 使用方式: source scripts/repo-config.sh

# 仓库基本信息
export REPO_NAME="Cix Repository"
export REPO_DESCRIPTION="Debian Trixie ARM64 CIX Packages Repo"

# APT 发行版配置
export REPO_CODENAME="trixie"
export REPO_SUITE="stable"
export REPO_COMPONENTS="main"
export REPO_ARCHITECTURES="arm64"

# GitHub Pages 配置
export REPO_URL="https://claystan404.github.io/cix-deb-repo"

# 本地仓库路径
export LOCAL_REPO_DIR="${LOCAL_REPO_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/local-repo}"

# 构建输出目录
export BUILD_DIR="${BUILD_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/build}"

# 导出配置摘要（用于调试）
repo-config::info() {
    cat <<INFO
仓库配置:
  名称: $REPO_NAME
  发行版: $REPO_CODENAME ($REPO_SUITE)
  架构: $REPO_ARCHITECTURES
  组件: $REPO_COMPONENTS
  本地仓库: $LOCAL_REPO_DIR
  构建目录: $BUILD_DIR
INFO
}

# 如果直接运行此脚本，显示配置信息
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    repo-config::info
fi
