# Cix Debian 仓库

Debian Trixie ARM64 APT 仓库，使用 GitHub Actions 自动构建 deb 包。

**架构**: ARM64 only | **签名**: ✓ GPG 签名

## 使用 APT 仓库

```bash
# 1. 导入 GPG 公钥
wget -qO- https://claystan404.github.io/cix-deb-repo/repository-key.asc | gpg --dearmor | sudo tee /usr/share/keyrings/cix-archive-keyring.gpg

# 2. 添加仓库源
echo "deb [signed-by=/usr/share/keyrings/cix-archive-keyring.gpg] https://claystan404.github.io/cix-deb-repo trixie main" | sudo tee /etc/apt/sources.list.d/cix.list

# 3. 更新并安装
sudo apt update
sudo apt install <package-name>
```

## 添加新包

在仓库根目录创建新项目目录，添加 `debian/` 目录和必需文件：

```
my-package/
├── debian/
│   ├── control          # 包的元数据
│   ├── changelog        # 版本历史
│   ├── rules            # 构建规则
│   └── install          # 安装文件列表（可选）
└── [源代码文件]
```

### debian/control 示例

```debian
Source: my-package
Section: utils
Priority: optional
Maintainer: Your Name <your.email@example.com>
Build-Depends: debhelper-compat (= 13)
Standards-Version: 4.6.2

Package: my-package
Architecture: any          # 构建 arm64 包
# Architecture: all        # 通用包
Depends: ${shlibs:Depends}, ${misc:Depends}
Description: Short description
 Long description.
 .
 More details.
```

## Workflow 工作流程

1. **discover** - 扫描所有包含 `debian/` 目录的项目
2. **build** - 使用交叉编译构建 ARM64 包
3. **create-repo** - 使用 reprepro 创建 APT 仓库并签名
4. **deploy** - 部署到 GitHub Pages

## 本地测试

```bash
# 本地构建
./scripts/local-build.sh

# 初始化本地仓库
./scripts/init-reprepro.sh

# 添加包到本地仓库
./scripts/add-to-repo.sh build/*.deb
```
