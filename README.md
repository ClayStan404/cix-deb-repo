# Cix Debian 仓库

Debian Trixie ARM64 APT 仓库，使用 GitHub Actions 自动构建 deb 包。

**架构**: ARM64 only

## 仓库结构

```
cix-deb-repo/
├── .github/
│   ├── workflows/
│   │   └── build-deb-repo.yml    # GitHub Actions workflow (ARM64 交叉编译)
│   └── apt-repo.conf             # APT 仓库配置
├── example-package/               # 示例项目
│   ├── debian/
│   │   ├── changelog
│   │   ├── control
│   │   ├── install
│   │   └── rules
│   └── example-package.sh
├── scripts/                       # 本地构建脚本
│   ├── local-build.sh
│   ├── init-reprepro.sh
│   └── add-to-repo.sh
└── README.md
```

## 添加新包

要添加一个新的 deb 包到仓库：

1. 在仓库根目录创建一个新的子目录（如 `my-package/`）
2. 在该目录下创建 `debian/` 目录和必需的文件
3. 提交并推送，GitHub Actions 会自动构建并添加到 APT 仓库

### debian/control 示例

```debian
Source: my-package
Section: utils
Priority: optional
Maintainer: Your Name <your.email@example.com>
Build-Depends: debhelper-compat (= 13)
Standards-Version: 4.6.2

Package: my-package
Architecture: any          # 构建为 arm64
# Architecture: all        # 通用包，所有架构可用
Depends: ${shlibs:Depends}, ${misc:Depends}
Description: Short description
 Long description.
 .
 More details.
```

### 架构说明

| Architecture 字段 | 构建结果 |
|-------------------|----------|
| `Architecture: any` | 构建 arm64 二进制包 |
| `Architecture: arm64` | 构建 arm64 二进制包 |
| `Architecture: all` | 构建架构无关包 |

## 使用 APT 仓库

```bash
# 添加仓库源
echo "deb [trusted=yes] https://claystan404.github.io/cix-deb-repo trixie main" | sudo tee /etc/apt/sources.list.d/cix.list

# 更新并安装
sudo apt update
sudo apt install <package-name>
```

## Workflow 工作流程

1. **discover** - 扫描所有包含 `debian/` 目录的项目
2. **build** - 使用交叉编译构建 ARM64 包
3. **create-repo** - 使用 reprepro 创建 APT 仓库
4. **deploy** - 部署到 GitHub Pages

## 本地测试

```bash
# 本地构建脚本
./scripts/local-build.sh

# 初始化本地仓库
./scripts/init-reprepro.sh

# 添加包到本地仓库
./scripts/add-to-repo.sh build/*.deb
```
