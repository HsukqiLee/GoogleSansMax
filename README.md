# GoogleSansMax

<div align="center">

<a href="#">
  <img src="https://img.shields.io/badge/Language-Chinese-blue?style=for-the-badge" alt="Chinese Version">
</a>
<a href="README.en.md">
  <img src="https://img.shields.io/badge/Language-English-red?style=for-the-badge" alt="English Version">
</a>

</div>

GoogleSansMax 是一款高度定制化、集大成者的 Magisk/KernelSU 字体模块。本项目的核心目标是为 Android 系统提供最全面、最优化的跨语种字体替换方案，同时从底层架构上解决传统字体模块普遍存在的冲突、字重丢失以及渲染缓存 Bug 等痛点问题。

## 字体覆盖与字重支持

### 总览

| 分类 | 字体族 | 字体文件 | 字重范围 | 样式 |
|---|---|---|---|---|
| **Latin 无衬线** | sans-serif | GoogleSansFlex-Regular.ttf | **100–1000** | normal + italic |
| **Latin 衬线** | serif | NotoSerif-VF.ttf | **100–900** | normal + italic |
| **Latin 等宽** | monospace | NotoSansMono-VF.ttf | **100–1000** | normal + italic |
| **CJK 无衬线** (ja/ko/zh-Hans/zh-Hant/zh-Bopo) | sans-serif | NotoSansCJK-VF.otf.ttc | **100–900** | normal |
| **CJK 衬线** (ja/ko/zh-Hans/zh-Hant/zh-Bopo) | serif (fallbackFor) | NotoSerifCJK-VF.otf.ttc | **200–900** | normal |
| **CJK 等宽** (ja/ko/zh-Hans/zh-Hant/zh-Bopo) | monospace | NotoSansCJK-VF.otf.ttc | **100–900** | normal |
| **Hentaigana** | ja fallback | NotoSerifHentaigana.ttf | **100–1000** | normal |

### 字重实现细节

**Google Sans Flex (Latin 无衬线)**
- 单个可变字体文件，`wght` 轴原生支持 1–1000
- 支持 `opsz` (6–144)、`wdth` (25–151)、`GRAD` (0–100)、`slnt` (-10–0) 等辅助轴
- fonts.xml 声明 100–1000 共 10 个标准字重档位，通过 `<axis tag="wght" stylevalue="N" />` 精确映射
- App 可通过 `fontVariationSettings` 在运行时设置任意字重（1–1000）

**Latin 衬线 (serif)**
- Noto Serif 可变字体，`wght` 轴支持 100–900
- CI 构建时从 notofonts.github.io 下载
- 所有字重通过 `<axis tag="wght" stylevalue="N" />` 精确映射
- 字重别名链: serif-thin(100)、serif-light(300)、serif-medium(400)、serif-semi-bold(500)、serif-bold(700)、serif-black(900)

**Noto Sans Mono (Latin 等宽)**
- CI 构建时从 Google Fonts 下载可变字体
- `wght` 轴支持 100–900（VF 原生范围），超出范围自动 clamp

**Noto CJK (中日韩)**
- VF `NotoSansCJK-VF.otf.ttc` 覆盖 100–900，`NotoSerifCJK-VF.otf.ttc` 覆盖 200–900
- CJK Black 字体内部 `usWeightClass=900`，与 VF 轴值 900 完全相同，因此无需单独声明 weight 1000
- 覆盖语言: 日语 (ja)、韩语 (ko)、简体中文 (zh-Hans)、繁体中文 (zh-Hant)、注音符号 (zh-Bopo)
- 所有 CJK 字重使用统一 `postScriptName`

**Emoji 引擎**: 在构建时自动同步上游最新资源，提供高兼容性的 CBDT (Bitmap) 与高清无损的 COLRv1 (Vector) 两种 Emoji 标准库供选。
- **生僻字补全**: 深度集成 `UnicodeFontSet` 核心代码，提供全 Unicode 字符集的 fallback 补全。

### WebUI 字重测试

模块内置字重测试 WebUI，安装后可通过 Magisk/KernelSU 管理器访问：
- 支持 Sans-Serif / Serif / Monospace / CJK 全家族字重预览
- 支持简体中文 / 繁体中文 / 日语 / 韩语切换
- 支持自定义文本测试
- 支持字符覆盖率查看
- 暗色/亮色主题自动切换

## 技术原理解析与 Bug 修复说明

在开发本项目时，我们深入调研了市面上主流的字体模块（如 `notocjk`, `Google-Sans-Plus`, `MakeFontsGreatAgain` 等），并针对它们存在的历史遗留问题进行了底层架构重构：

### 1. 解决多模块共存时的 `fonts.xml` 冲突灾难
- **原模块问题分析**: 绝大多数“简单替换型”字体模块会直接通过 Magisk 的 Magic Mount 机制盲目覆盖替换系统的 `/system/etc/fonts.xml`。当用户安装多个字体模块时，后加载的模块会暴力覆盖前者的 XML 文件，导致此前的配置全部失效。此外，这种盲目覆盖也会破坏各家手机厂商 (OEM) 针对自身 UI 定制的私有字体节点配置。
- **本模块解决方案**: 我们摒弃了静态覆盖替换 XML 的做法。本模块在安装阶段使用高精度的 `sed` 动态解析与替换逻辑：
  1. 首先对系统原生的 `fonts.xml` 进行特定节点（如 `sans-serif` 和 `zh-Hans` 等）的精细化替换，保留 OEM 的私有配置。
  2. 随后，无缝对接 `UnicodeFontSet` 的高级 DOM 注入脚本，将复杂的 Unicode fallback 节点追加至文件尾部。
  所有修改均在一个统一的流水线中于安装期（Install-time）完成，从而在根源上杜绝了模块间覆写冲突导致的字重不全或字符丢失问题。

### 2. 强制 Google 全家桶应用生效 (Kill GMS Font)
- **原模块问题分析**: 当你成功将系统字体替换为 Google Sans 后，你会发现 Google 的第一方应用（如 Google 负一屏、Google 地图、Google 商店等）依然使用着它们自带的字体，甚至导致中日韩字重显示异常。这是因为 Google Play 服务 (GMS) 内部拥有一个 `FontsProvider`，它会绕过系统字体，私自将字体缓存下载至 `/data/` 分区供应用调用。
- **本模块解决方案**: 我们深度整合了 `killgmsfont` 的核心拦截逻辑。模块会在开机后静默禁用 GMS 的字体更新服务，并自动清空其私自下载的字体缓存目录。通过此机制，我们强制要求所有的 Google 官方应用回退使用系统底层的 `GoogleSansMax`，从而确保全局（包含 Google 全家桶）字体渲染的绝对统一。

### 3. Firefox 兼容性 (Gecko 引擎忽略 `lang` 标签)

Firefox 的 Gecko 引擎在解析网页字体时，会忽略 Android `fonts.xml` / `font_fallback.xml` 中带有 `lang` 属性的 CJK 家族（这些标签对其他浏览器和系统 UI 正常）。因此，仅依赖 `lang="zh-Hans"` 等标签来挂载 CJK VF 字体的配置无法被 Firefox 识别。

**解决方案**: 在 `fonts.xml` 和 `font_fallback.xml` 末尾分别追加一条**无 `lang` 标签**的全局 CJK fallback 条目，使用系统静态字体 `NotoSansCJK-Regular.ttc`（非 VF、无 axis 标签），确保 Gecko 引擎能正确解析 CJK 字符。


## 构建版本与下载

本仓库利用 GitHub Actions 自动进行矩阵构建，并在每次 Release 时生成三个变种分支：

1. **GoogleSansMax-Core.zip**
   - 核心版：仅包含 Google Sans 与 Noto CJK。轻量化，无多余负担。
2. **GoogleSansMax-Unicode-CBDT.zip**
   - 兼容版：核心版 + 全 Unicode 补全 + NotoColorEmoji (CBDT 位图格式)。
   - 具有极高的系统兼容性（支持 Android 4.4+），确保在所有旧设备上亦能显示现代 Emoji。
3. **GoogleSansMax-Unicode-COLRv1.zip**
   - 矢量版：核心版 + 全 Unicode 补全 + Noto-COLRv1 (COLRv1 矢量格式)。
   - 采用次世代无损矢量 Emoji 格式，无论如何缩放均不失真（仅限支持该特性的 Android 13+ 系统）。

## 自动同步机制

本仓库配置了 GitHub Actions 自动化工作流。每周会自动从 `UnicodeFontSet-magisk-module` 的上游仓库拉取最新的生僻字与 Unicode 数据资源。发现更新时，机器人会自动提交并触发全新的 Release 构建，确保本模块所包含的字符库始终处于业界最前沿。

## 安装步骤
1. 前往 [Releases](#) 页面下载适合你的版本。
2. 在 Magisk 或 KernelSU 等管理器中刷入。
3. 重启设备。

## 🛠 基于本仓库定制属于你的字体模块

本项目已被设计为 Public Template（公共模板）。你可以直接 Fork 本仓库，用来快速构建属于你自己的 Magisk / KernelSU 字体模块，同时享有本项目的高级 XML 解析注入技术和热更新机制。

### 定制指南

1. **替换字体文件**
   - 将你自己的字体文件放入 `system/fonts/` 目录。
   - **最简单的替换方式**：直接将你的字体文件重命名为原有的文件名（例如 `GoogleSansFlex-Regular.ttf` 或 `NotoSansCJK-VF.otf.ttc`）并覆盖替换。
   - **提示**：本项目默认采用可变字体（Variable Font）的 `wght` 轴来映射字重。如果你要换成多字重的静态字体文件，需要修改 `customize.sh` 中的 `generate_xxx_xml` 相关函数。

2. **修改模块信息**
   - 修改项目根目录下的 `module.prop`：更改 `id`、`name`、`version`、`versionCode`、`author` 和 `description`。**注意：** 确保 `id` 唯一，避免与其他模块冲突。

3. **修改构建脚本 (可选)**
   - 本项目通过 GitHub Actions 自动打包。如果你改变了字体文件的来源，或者想在打包时下载特定的字体，请修改 `.github/workflows/release.yml` 中的下载链接和构建逻辑。
   - 如果你修改了字体文件名，请同步修改 `customize.sh` 和 `action.sh` 中对应的文件名和字重生成逻辑。

4. **发布属于你的版本**
   - 在 GitHub 的 Releases 页面发布一个新的 Tag，即可自动触发 Actions 构建并打包发布你的 ZIP 文件。

## 鸣谢
- [simonsmh / notocjk](https://github.com/simonsmh/notocjk)
- [Magisk-Modules-Alt-Repo / Google-Sans-Plus](https://github.com/Magisk-Modules-Alt-Repo/Google-Sans-Plus)
- [Losketch / UnicodeFontSet-magisk-module](https://github.com/Losketch/UnicodeFontSet-magisk-module)
- [MrCarb0n / killgmsfont](https://github.com/MrCarb0n/killgmsfont)
- [Numbersf / MakeFontsGreatAgain](https://github.com/Numbersf/MakeFontsGreatAgain)
- [YuKongA / Font-Weight-Test](https://github.com/YuKongA/Font-Weight-Test)
- [YuKongA / Font-Weight-Test-KMP](https://github.com/YuKongA/Font_Weight_Test-KMP)
- [Google Fonts](https://fonts.google.com/)
