# Cix Debian 仓库

这个仓库使用 GitHub Actions 自动构建 deb 包并发布为 APT 仓库。

## 仓库结构

```
cix-deb-repo/
├── .github/
│   └── workflows/
│       └── build-deb-repo.yml    # 主要的 GitHub Actions workflow
├── example-package/               # 示例项目
│   ├── debian/
│   │   ├── changelog
│   │   ├── compat
│   │   ├── control
│   │   ├── install
│   │   └── rules
│   └── example-package.sh
└── README.md
```

## 添加新包

要添加一个新的 deb 包到仓库：

1. 在仓库根目录创建一个新的子目录（如 `my-package/`）
2. 在该目录下创建 `debian/` 目录和必需的文件：

```
my-package/
├── debian/
│   ├── control          # 包的元数据
│   ├── changelog        # 版本历史
│   ├── rules            # 构建规则
│   ├── compat           # debhelper 兼容级别
│   └── install          # 安装文件列表（可选）
└── [源代码文件]
```

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
Architecture: any
Depends: ${shlibs:Depends}, ${misc:Depends}
Description: Short description
 Long description of what this package does.
 .
 More details can be added here.
```

### debian/changelog 示例

```debian
my-package (1.0.0-1) unstable; urgency=medium

  * Initial release

 -- Your Name <your.email@example.com>  $(date -R)
```

## GitHub Secrets 配置

需要在 GitHub 仓库设置中添加以下 Secrets：

1. **GPG_PRIVATE_KEY**: 你的 GPG 私钥（ASCII-armored 格式）
2. **GPG_PASSPHRASE**: GPG 私钥的密码

### 生成 GPG 密钥

```bash
# 生成新密钥
gpg --full-generate-key

# 导出私钥（用于 GitHub Secrets）
gpg --armor --export-secret-keys your@email.com

# 导出公钥（用于分发）
gpg --armor --export your@email.com
```

## GitHub Pages 配置

1. 进入仓库 Settings > Pages
2. Source 选择 "GitHub Actions"
3. 仓库构建后，APT 仓库将发布在：
   `https://<username>.github.io/<repo>/`

## 使用 APT 仓库

客户端可以通过以下方式使用仓库：

```bash
# 1. 导入 GPG 密钥
wget -qO- https://<username>.github.io/<repo>/repository-key.asc | gpg --dearmor | sudo tee /usr/share/keyrings/cix-archive-keyring.gpg

# 2. 添加仓库源
echo "deb [signed-by=/usr/share/keyrings/cix-archive-keyring.gpg] https://<username>.github.io/<repo> trixie main" | sudo tee /etc/apt/sources.list.d/cix.list

# 3. 更新并安装
sudo apt update
sudo apt install <package-name>
```

## Workflow 工作流程

1. **discover** - 发现阶段：扫描仓库中所有包含 `debian/` 目录的项目
2. **build** - 构建阶段：并行构建每个项目的 deb 包
3. **create-repo** - 仓库创建：使用 reprepro 创建 APT 仓库结构
4. **deploy** - 部署：将仓库发布到 GitHub Pages

## 本地测试

在本地测试包构建：

```bash
cd <package-directory>
dpkg-buildpackage -uc -us
```

或使用 pbuilder 构建干净环境：

```bash
sudo pbuilder create --distribution sid
cd <package-directory>
sudo pdebuild
```
