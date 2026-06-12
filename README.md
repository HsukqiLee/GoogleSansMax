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
| **CJK 无衬线** (ja/ko/zh-Hans/zh-Hant/zh-Bopo) | sans-serif | NotoSansCJK-VF.otf.ttc + NotoSansCJK{jp,kr,sc,tc}-Black.otf | **100–1000** | normal |
| **CJK 衬线** (ja/ko/zh-Hans/zh-Hant/zh-Bopo) | serif (fallbackFor) | NotoSerifCJK-VF.otf.ttc + NotoSerifCJK{jp,kr,sc,tc}-Black.otf | **200–1000** | normal |
| **CJK 等宽** (ja/ko/zh-Hans/zh-Hant/zh-Bopo) | monospace | NotoSansCJK-VF.otf.ttc + NotoSansCJK{jp,kr,sc,tc}-Black.otf | **100–1000** | normal |
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
- 采用 VF + 静态字体混合方案实现 100–1000：
  - **CJK 无衬线**: VF `NotoSansCJK-VF.otf.ttc` (100-900) + 每语言静态 `NotoSansCJK{jp,kr,sc,tc}-Black.otf` (1000)
  - **CJK 衬线**: VF `NotoSerifCJK-VF.otf.ttc` (200-900) + 每语言静态 `NotoSerifCJK{jp,kr,sc,tc}-Black.otf` (1000)
  - **CJK 等宽**: 在 monospace family 中添加 CJK 条目，与 CJK 无衬线相同配置
- 覆盖语言: 日语 (ja)、韩语 (ko)、简体中文 (zh-Hans)、繁体中文 (zh-Hant)、注音符号 (zh-Bopo)
- 所有 CJK 字重使用统一 `postScriptName` 避免 Android 16/17 缓存 Bug

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

### 1. 修复 Android 16/17 CJK 100/200 字重显示相同的 Bug
- **原模块问题分析**: 在之前的模块（如 `notocjk`）中，为了在 `fonts.xml` 中映射 100-900 全字重，其 XML 节点配置对所有 9 个字重档位均使用了相同的 `postScriptName="NotoSansCJKjp-Thin"`，仅依靠 `<axis tag="wght" stylevalue="..."/>` 参数来区分。在 Android 16/17 中，底层的字体渲染与缓存引擎（Minikin）行为发生了改变，由于 100 与 200 字重的节点共享了完全相同的 `postScriptName`，缓存引擎误将它们视为同一字体实例，导致 200 字重复用了 100 字重的渲染缓存，使得两者在视觉上完全一致。
- **本模块解决方案**: 在我们的 `customize.sh` 脚本中，为每一个变体轴实例（Axis Instance）显式分配了标准且唯一的 `postScriptName`（例如 100 对应 `Thin`，200 对应 `ExtraLight`，400 对应 `Regular` 等）。这强制 Android 字体缓存引擎将每个字重作为独立的实体进行处理，彻底消除了缓存重叠问题。

### 2. 解决多模块共存时的 `fonts.xml` 冲突灾难
- **原模块问题分析**: 绝大多数“简单替换型”字体模块会直接通过 Magisk 的 Magic Mount 机制盲目覆盖替换系统的 `/system/etc/fonts.xml`。当用户安装多个字体模块时，后加载的模块会暴力覆盖前者的 XML 文件，导致此前的配置全部失效。此外，这种盲目覆盖也会破坏各家手机厂商 (OEM) 针对自身 UI 定制的私有字体节点配置。
- **本模块解决方案**: 我们摒弃了静态覆盖替换 XML 的做法。本模块在安装阶段使用高精度的 `sed` 动态解析与替换逻辑：
  1. 首先对系统原生的 `fonts.xml` 进行特定节点（如 `sans-serif` 和 `zh-Hans` 等）的精细化替换，保留 OEM 的私有配置。
  2. 随后，无缝对接 `UnicodeFontSet` 的高级 DOM 注入脚本，将复杂的 Unicode fallback 节点追加至文件尾部。
  所有修改均在一个统一的流水线中于安装期（Install-time）完成，从而在根源上杜绝了模块间覆写冲突导致的字重不全或字符丢失问题。

### 3. 强制 Google 全家桶应用生效 (Kill GMS Font)
- **原模块问题分析**: 当你成功将系统字体替换为 Google Sans 后，你会发现 Google 的第一方应用（如 Google 负一屏、Google 地图、Google 商店等）依然使用着它们自带的字体，甚至导致中日韩字重显示异常。这是因为 Google Play 服务 (GMS) 内部拥有一个 `FontsProvider`，它会绕过系统字体，私自将字体缓存下载至 `/data/` 分区供应用调用。
- **本模块解决方案**: 我们深度整合了 `killgmsfont` 的核心拦截逻辑。模块会在开机后静默禁用 GMS 的字体更新服务，并自动清空其私自下载的字体缓存目录。通过此机制，我们强制要求所有的 Google 官方应用回退使用系统底层的 `GoogleSansMax`，从而确保全局（包含 Google 全家桶）字体渲染的绝对统一。


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

## 鸣谢
- [simonsmh / notocjk](https://github.com/simonsmh/notocjk)
- [Magisk-Modules-Alt-Repo / Google-Sans-Plus](https://github.com/Magisk-Modules-Alt-Repo/Google-Sans-Plus)
- [Losketch / UnicodeFontSet-magisk-module](https://github.com/Losketch/UnicodeFontSet-magisk-module)
- [MrCarb0n / killgmsfont](https://github.com/MrCarb0n/killgmsfont)
- [Numbersf / MakeFontsGreatAgain](https://github.com/Numbersf/MakeFontsGreatAgain)
- [YuKongA / Font-Weight-Test](https://github.com/YuKongA/Font-Weight-Test) — WebUI 字重测试参考
- [YuKongA / Font-Weight-Test-KMP](https://github.com/YuKongA/Font_Weight_Test-KMP) — KMP 跨平台字重测试参考
- **Google Fonts**
