#!/bin/bash
# 本地构建脚本 - 用于在本地测试包构建

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# 加载共享配置
source "$SCRIPT_DIR/repo-config.sh"

REPO_ROOT="$(dirname "$SCRIPT_DIR")"

echo "=== Cix Debian 仓库 - 本地构建脚本 ==="
repo-config::info
echo ""

# 查找所有包含 debian/ 目录的项目（使用共享函数）
echo "正在查找项目..."
PROJECTS=$(repo-config::find_projects "$REPO_ROOT")

if [ -z "$PROJECTS" ]; then
    echo "❌ 未找到任何包含 debian/ 目录的项目"
    exit 1
fi

echo "找到以下项目:"
echo "$PROJECTS"
echo ""

# 创建输出目录
mkdir -p "$BUILD_DIR"

# 统计变量
total_count=0
success_count=0
failed_count=0
failed_projects=()

# 构建每个项目
for project in $PROJECTS; do
    ((total_count++))
    echo "=== [$total_count] 构建 $project ==="
    cd "$REPO_ROOT/$project"

    if [ ! -f debian/control ]; then
        echo "⚠️  警告: debian/control 不存在，跳过"
        continue
    fi

    # 获取包名
    package_name=$(grep "^Package:" debian/control | head -1 | awk '{print $2}')
    echo "包名: $package_name"

    # 安装构建依赖
    echo "安装构建依赖..."
    if ! sudo mk-build-deps --install --tool='apt-get --no-install-recommends -y' 2>/dev/null; then
        echo "⚠️  mk-build-deps 失败，尝试 apt-get build-dep..."
        sudo apt-get build-dep -y . 2>/dev/null || echo "⚠️  警告: 无法安装所有构建依赖"
    fi

    # 构建包
    echo "构建 deb 包..."
    if dpkg-buildpackage -b -uc -us; then
        ((success_count++))
        echo "✓ $package_name 构建成功"
    else
        ((failed_count++))
        failed_projects+=("$project")
        echo "❌ $package_name 构建失败"
        cd "$REPO_ROOT"
        continue
    fi

    # 移动构建的包
    cd "$REPO_ROOT"
    find . -maxdepth 1 -name "*.deb" -exec mv {} "$BUILD_DIR/" \; 2>/dev/null || true
    find . -maxdepth 1 -name "*.changes" -exec mv {} "$BUILD_DIR/" \; 2>/dev/null || true

    echo ""
done

# 构建总结
echo "=== 构建总结 ==="
echo "总计: $total_count 个项目"
echo "成功: $success_count"
echo "失败: $failed_count"

if [ "$failed_count" -gt 0 ]; then
    echo ""
    echo "失败的项目:"
    for project in "${failed_projects[@]}"; do
        echo "  - $project"
    done
    exit 1
fi

echo ""
echo "输出目录: $BUILD_DIR"
echo ""
echo "生成的包:"
ls -lh "$BUILD_DIR"/*.deb 2>/dev/null || echo "没有生成 deb 文件"
