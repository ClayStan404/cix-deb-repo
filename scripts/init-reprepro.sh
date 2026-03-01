#!/bin/bash
# 本地 reprepro 仓库初始化脚本

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
REPO_DIR="$REPO_ROOT/local-repo"

echo "=== 初始化本地 reprepro APT 仓库 ==="
echo ""

# 清理旧的仓库
if [ -d "$REPO_DIR" ]; then
    read -p "仓库目录已存在，是否删除并重新创建? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$REPO_DIR"
    else
        echo "取消操作"
        exit 0
    fi
fi

# 创建目录结构
mkdir -p "$REPO_DIR/conf"

# 创建 distributions 配置
cat > "$REPO_DIR/conf/distributions" << 'EOF'
Origin: Cix Repository
Label: Debian Trixie arm64 CIX Packages Repo
Suite: stable
Codename: trixie
Architectures: arm64 source
Components: main
Description: APT repository for Cix packages
SignWith: yes
EOF

# 创建 options 配置（可选）
cat > "$REPO_DIR/conf/options" << 'EOF'
verbose
ask-passphrase
EOF

echo "✓ reprepro 仓库配置已创建在: $REPO_DIR"
echo ""
echo "配置文件:"
echo "  - $REPO_DIR/conf/distributions"
echo "  - $REPO_DIR/conf/options"
echo ""
echo "下一步:"
echo "1. 构建你的 deb 包: ./scripts/local-build.sh"
echo "2. 添加包到仓库: reprepro -b $REPO_DIR includedeb debian13 <package.deb>"
echo ""
echo "或者使用 ./scripts/add-to-repo.sh <package.deb>"
