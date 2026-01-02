# 快速开始指南

## 🎯 构建项目只需两步

### 第 1 步: 下载 NetMusic 依赖

运行下载脚本：

```powershell
# Windows - 在项目根目录运行
.\download-dependency.ps1
```

```bash
# Linux/Mac - 在项目根目录运行
chmod +x download-dependency.sh
./download-dependency.sh
```

脚本会自动：
- 创建 `libs/` 目录
- 尝试从多个源下载 NetMusic
- 验证下载是否成功

**如果脚本失败**，手动下载：
1. 访问: https://modrinth.com/mod/net-music/versions （作者 TartaricAcid，选择 1.2.1 Fabric 1.21.1）
2. 点击下载按钮
3. 将下载的 NetMusic 1.2.1 (Fabric 1.21.1) jar 移动到项目的 `libs/` 文件夹

### 第 2 步: 构建项目

```powershell
# Windows
.\gradlew.bat build
```

```bash
# Linux/Mac
./gradlew build
```

构建完成后，在 `build/libs/` 目录找到生成的 mod 文件。

## ✅ 验证依赖

如果不确定是否已下载依赖，检查 `libs/` 目录：

```powershell
# Windows
dir libs\*.jar

# Linux/Mac
ls -lh libs/*.jar
```

应该看到类似这样的文件（文件名可能包含 1.2.1 且标注 Fabric 1.21.1）：
```
netmusic-1.2.1-fabric+mc1.21.1.jar
```

## 🔍 常见问题

### 问: 为什么不能自动下载？

答: 由于网络配置或防火墙限制，自动下载可能失败。手动下载或使用辅助脚本更可靠。

### 问: 下载脚本失败怎么办？

答: 手动下载并放入 `libs/` 目录：
1. 打开浏览器访问 Modrinth
2. 下载对应版本的 jar 文件
3. 移动到项目的 `libs/` 文件夹

### 问: 如何更新 NetMusic 版本？

答: 
1. 删除 `libs/` 中的旧文件
2. 下载新版本的 jar 文件
3. 放入 `libs/` 目录
4. 重新构建

## 📚 更多信息

- 详细构建指南: [BUILD_GUIDE.md](BUILD_GUIDE.md)
- 项目说明: [readme.md](readme.md)
- 依赖配置: [DEPENDENCY_SETUP.md](DEPENDENCY_SETUP.md)
