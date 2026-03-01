#!/bin/bash
# 清理脚本 - 删除构建产物和临时文件

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# 加载共享配置
source "$SCRIPT_DIR/repo-config.sh"

REPO_ROOT="$(dirname "$SCRIPT_DIR")"

echo "=== Cix Debian 仓库 - 清理脚本 ==="
echo ""

# 函数：询问确认
ask_confirm() {
    local prompt="$1"
    local default="${2:-n}"
    local reply

    if [ "$default" = "y" ]; then
        prompt="$prompt [Y/n]"
    else
        prompt="$prompt [y/N]"
    fi

    read -p "$prompt " -n 1 -r reply
    echo
    [[ $reply =~ ^[Yy]$ ]] || ([ "$default" = "y" ] && [[ ! $reply =~ ^[Nn]$ ]])
}

# 清理构建产物
if [ -d "$BUILD_DIR" ]; then
    echo "📦 构建目录: $BUILD_DIR"
    deb_count=$(find "$BUILD_DIR" -name "*.deb" 2>/dev/null | wc -l)
    echo "   包含 $deb_count 个 deb 文件"
fi

# 清理项目根目录中的临时文件
temp_debs=$(find "$REPO_ROOT" -maxdepth 1 -name "*.deb" 2>/dev/null | wc -l)
temp_changes=$(find "$REPO_ROOT" -maxdepth 1 -name "*.changes" 2>/dev/null | wc -l)
temp_buildinfo=$(find "$REPO_ROOT" -maxdepth 1 -name "*.buildinfo" 2>/dev/null | wc -l)

echo ""
echo "🧹 临时文件（项目根目录）:"
echo "   *.deb: $temp_debs"
echo "   *.changes: $temp_changes"
echo "   *.buildinfo: $temp_buildinfo"

# 清理本地仓库
if [ -d "$LOCAL_REPO_DIR" ]; then
    echo ""
    echo "📁 本地仓库: $LOCAL_REPO_DIR"
fi

echo ""
echo "清理选项:"
echo "  1) 清理构建产物 ($BUILD_DIR)"
echo "  2) 清理根目录临时文件"
echo "  3) 清理本地仓库 ($LOCAL_REPO_DIR)"
echo "  4) 全部清理"
echo "  5) 仅显示，不清理"
echo "  q) 退出"
echo ""

read -p "选择操作 [1-5/q]: " -n 1 -r choice
echo ""
echo ""

case "$choice" in
    1)
        if [ -d "$BUILD_DIR" ]; then
            if ask_confirm "确认删除构建目录?" "n"; then
                rm -rf "$BUILD_DIR"
                echo "✓ 已删除构建目录"
            else
                echo "已取消"
            fi
        else
            echo "构建目录不存在"
        fi
        ;;
    2)
        if ask_confirm "确认删除根目录临时文件?" "n"; then
            find "$REPO_ROOT" -maxdepth 1 \( -name "*.deb" -o -name "*.changes" -o -name "*.buildinfo" -o -name "*.dsc" \) -delete 2>/dev/null || true
            echo "✓ 已删除临时文件"
        else
            echo "已取消"
        fi
        ;;
    3)
        if [ -d "$LOCAL_REPO_DIR" ]; then
            if ask_confirm "确认删除本地仓库? (需要重新运行 init-reprepro.sh)" "n"; then
                rm -rf "$LOCAL_REPO_DIR"
                echo "✓ 已删除本地仓库"
            else
                echo "已取消"
            fi
        else
            echo "本地仓库不存在"
        fi
        ;;
    4)
        if ask_confirm "确认全部清理?" "n"; then
            [ -d "$BUILD_DIR" ] && rm -rf "$BUILD_DIR"
            find "$REPO_ROOT" -maxdepth 1 \( -name "*.deb" -o -name "*.changes" -o -name "*.buildinfo" -o -name "*.dsc" \) -delete 2>/dev/null || true
            [ -d "$LOCAL_REPO_DIR" ] && rm -rf "$LOCAL_REPO_DIR"
            echo "✓ 已全部清理"
        else
            echo "已取消"
        fi
        ;;
    5)
        echo "仅显示模式，未执行清理"
        ;;
    q|Q)
        echo "退出"
        exit 0
        ;;
    *)
        echo "无效选择"
        exit 1
        ;;
esac

echo ""
echo "剩余文件:"
[ -d "$BUILD_DIR" ] && echo "  构建目录: $(du -sh "$BUILD_DIR" 2>/dev/null | cut -f1)" || echo "  构建目录: 不存在"
[ -d "$LOCAL_REPO_DIR" ] && echo "  本地仓库: $(du -sh "$LOCAL_REPO_DIR" 2>/dev/null | cut -f1)" || echo "  本地仓库: 不存在"
