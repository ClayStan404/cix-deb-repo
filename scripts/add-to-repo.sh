#!/bin/bash
# 添加 deb 包到本地 reprepro 仓库

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# 加载共享配置
source "$SCRIPT_DIR/repo-config.sh"

if [ ! -d "$LOCAL_REPO_DIR" ]; then
    echo "错误: reprepro 仓库不存在，请先运行 ./scripts/init-reprepro.sh"
    exit 1
fi

if [ $# -eq 0 ]; then
    echo "用法: $0 <package.deb> [package2.deb] ..."
    echo ""
    echo "添加所有构建的包:"
    echo "  $0 $BUILD_DIR/*.deb"
    exit 1
fi

echo "=== 添加包到 APT 仓库 ==="
echo "仓库: $LOCAL_REPO_DIR"
echo "发行版: $REPO_CODENAME"
echo ""

added_count=0
skipped_count=0

for deb in "$@"; do
    if [ ! -f "$deb" ]; then
        echo "⚠️  警告: $deb 不存在，跳过"
        ((skipped_count++))
        continue
    fi

    echo "→ 添加: $deb"
    if reprepro -b "$LOCAL_REPO_DIR" includedeb "$REPO_CODENAME" "$deb"; then
        ((added_count++))
    else
        echo "❌ 错误: 添加 $deb 失败"
        exit 1
    fi
done

echo ""
echo "✓ 完成: 添加了 $added_count 个包"
if [ "$skipped_count" -gt 0 ]; then
    echo "  跳过 $skipped_count 个不存在的文件"
fi
echo ""
echo "仓库已更新，可以配置 APT 源:"
echo ""
echo "  echo 'deb [trusted=yes] file://$LOCAL_REPO_DIR $REPO_CODENAME $REPO_COMPONENTS' | sudo tee /etc/apt/sources.list.d/cix-local.list"
echo "  sudo apt update"
