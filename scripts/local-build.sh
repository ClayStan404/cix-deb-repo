#!/bin/bash
# 本地构建脚本 - 用于在本地测试包构建

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

echo "=== Cix Debian 仓库 - 本地构建脚本 ==="
echo ""

# 查找所有包含 debian/ 目录的项目
echo "正在查找项目..."
PROJECTS=$(find "$REPO_ROOT" -mindepth 2 -maxdepth 4 -type d -name "debian" | sed "s|$REPO_ROOT/||" | sed 's|/debian||')

if [ -z "$PROJECTS" ]; then
    echo "未找到任何包含 debian/ 目录的项目"
    exit 1
fi

echo "找到以下项目:"
echo "$PROJECTS"
echo ""

# 创建输出目录
OUTPUT_DIR="$REPO_ROOT/build"
mkdir -p "$OUTPUT_DIR"

# 构建每个项目
for project in $PROJECTS; do
    echo "=== 构建 $project ==="
    cd "$REPO_ROOT/$project"

    if [ ! -f debian/control ]; then
        echo "警告: debian/control 不存在，跳过"
        continue
    fi

    # 安装构建依赖
    echo "安装构建依赖..."
    sudo mk-build-deps --install --tool='apt-get --no-install-recommends -y' 2>/dev/null || true

    # 构建包
    echo "构建 deb 包..."
    dpkg-buildpackage -b -uc -us

    # 移动构建的包
    cd "$REPO_ROOT"
    find . -maxdepth 1 -name "*.deb" -exec mv {} "$OUTPUT_DIR/" \;
    find . -maxdepth 1 -name "*.changes" -exec mv {} "$OUTPUT_DIR/" \;

    echo "✓ $project 构建完成"
    echo ""
done

echo "=== 构建完成 ==="
echo "输出目录: $OUTPUT_DIR"
ls -lh "$OUTPUT_DIR"/*.deb 2>/dev/null || echo "没有生成 deb 文件"
