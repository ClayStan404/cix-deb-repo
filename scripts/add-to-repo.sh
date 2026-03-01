#!/bin/bash
# 添加 deb 包到本地 reprepro 仓库

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
REPO_DIR="$REPO_ROOT/local-repo"

if [ ! -d "$REPO_DIR" ]; then
    echo "错误: reprepro 仓库不存在，请先运行 ./scripts/init-reprepro.sh"
    exit 1
fi

if [ $# -eq 0 ]; then
    echo "用法: $0 <package.deb> [package2.deb] ..."
    echo ""
    echo "添加所有构建的包:"
    echo "  $0 build/*.deb"
    exit 1
fi

echo "=== 添加包到 APT 仓库 ==="
echo ""

for deb in "$@"; do
    if [ ! -f "$deb" ]; then
        echo "警告: $deb 不存在，跳过"
        continue
    fi

    echo "添加: $deb"
    reprepro -b "$REPO_DIR" includedeb debian13 "$deb"
done

echo ""
echo "✓ 完成"
echo ""
echo "仓库已更新，可以配置 APT 源:"
echo ""
echo "  echo 'deb [trusted=yes] file://$REPO_DIR debian13 main' | sudo tee /etc/apt/sources.list.d/cix-local.list"
echo "  sudo apt update"
