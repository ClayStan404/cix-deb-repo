#!/bin/bash
# 本地 reprepro 仓库初始化脚本

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# 加载共享配置
source "$SCRIPT_DIR/repo-config.sh"

echo "=== 初始化本地 reprepro APT 仓库 ==="
repo-config::info
echo ""

# 清理旧的仓库
if [ -d "$LOCAL_REPO_DIR" ]; then
    read -p "仓库目录已存在，是否删除并重新创建? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$LOCAL_REPO_DIR"
    else
        echo "取消操作"
        exit 0
    fi
fi

# 创建目录结构
mkdir -p "$LOCAL_REPO_DIR/conf"

# 创建 distributions 配置（使用共享配置）
cat > "$LOCAL_REPO_DIR/conf/distributions" <<EOF
Origin: $REPO_NAME
Label: $REPO_DESCRIPTION
Suite: $REPO_SUITE
Codename: $REPO_CODENAME
Architectures: $REPO_ARCHITECTURES source
Components: $REPO_COMPONENTS
Description: $REPO_DESCRIPTION
SignWith: yes
EOF

# 创建 options 配置
cat > "$LOCAL_REPO_DIR/conf/options" <<EOF
verbose
ask-passphrase
EOF

echo "✓ reprepro 仓库配置已创建在: $LOCAL_REPO_DIR"
echo ""
echo "配置文件:"
echo "  - $LOCAL_REPO_DIR/conf/distributions"
echo "  - $LOCAL_REPO_DIR/conf/options"
echo ""
echo "下一步:"
echo "1. 构建你的 deb 包: ./scripts/local-build.sh"
echo "2. 添加包到仓库: reprepro -b $LOCAL_REPO_DIR includedeb $REPO_CODENAME <package.deb>"
echo ""
echo "或者使用 ./scripts/add-to-repo.sh <package.deb>"
