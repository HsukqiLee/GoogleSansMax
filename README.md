# GoogleSansMax

<div align="center">

<a href="#">
  <img src="https://img.shields.io/badge/Language-Chinese-blue?style=for-the-badge" alt="Chinese Version">
</a>
<a href="README.en.md">
  <img src="https://img.shields.io/badge/Language-English-red?style=for-the-badge" alt="English Version">
</a>
<a href="https://app.fossa.com/projects/git%2Bgithub.com%2FHsukqiLee%2FGoogleSansMax?ref=badge_shield" alt="FOSSA Status"><img src="https://app.fossa.com/api/projects/git%2Bgithub.com%2FHsukqiLee%2FGoogleSansMax.svg?type=shield"/></a>

</div>

<div align="center">

![GitHub release](https://img.shields.io/github/v/release/HsukqiLee/GoogleSansMax)
![GitHub downloads](https://img.shields.io/github/downloads/HsukqiLee/GoogleSansMax/total)
![Build status](https://img.shields.io/github/actions/workflow/status/HsukqiLee/GoogleSansMax/release.yml?branch=main)
![Platform](https://img.shields.io/badge/platform-Magisk%20%7C%20KernelSU-blue)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/47fe59571c55436b9fd1f16d9e8a7935)](https://app.codacy.com/gh/TsinbeiLabs/GoogleSansMax/dashboard)
[![FOSSA License](https://app.fossa.com/api/projects/git%2Bgithub.com%2FHsukqiLee%2FGoogleSansMax.svg?type=shield&issueType=license)](https://app.fossa.com/projects/git%2Bgithub.com%2FHsukqiLee%2FGoogleSansMax?ref=badge_shield&issueType=license)
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FHsukqiLee%2FGoogleSansMax.svg?type=shield&issueType=security)](https://app.fossa.com/projects/git%2Bgithub.com%2FHsukqiLee%2FGoogleSansMax?ref=badge_shield&issueType=security)

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

详细字重实现说明见 [docs/weight-implementation.md](docs/weight-implementation.md)。

### WebUI 字重测试

模块内置字重测试 WebUI，安装后可通过 Magisk/KernelSU 管理器访问：
- 支持 Sans-Serif / Serif / Monospace / CJK 全家族字重预览
- 支持简体中文 / 繁体中文 / 日语 / 韩语切换
- 支持自定义文本测试
- 支持字符覆盖率查看
- 暗色/亮色主题自动切换

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

## 文档导航

- [**技术原理解析与 Bug 修复说明**](docs/technical-analysis.md) — 多模块 fonts.xml 冲突解决方案、Kill GMS Font 机制、Firefox 兼容性处理
- [**基于本仓库定制属于你的字体模块**](docs/customization-guide.md) — 字体类型判断、分场景替换指南、XML 生成逻辑修改、发布流程

## 鸣谢
- [simonsmh / notocjk](https://github.com/simonsmh/notocjk)
- [Magisk-Modules-Alt-Repo / Google-Sans-Plus](https://github.com/Magisk-Modules-Alt-Repo/Google-Sans-Plus)
- [Losketch / UnicodeFontSet-magisk-module](https://github.com/Losketch/UnicodeFontSet-magisk-module)
- [MrCarb0n / killgmsfont](https://github.com/MrCarb0n/killgmsfont)
- [Numbersf / MakeFontsGreatAgain](https://github.com/Numbersf/MakeFontsGreatAgain)
- [YuKongA / Font-Weight-Test](https://github.com/YuKongA/Font-Weight-Test)
- [YuKongA / Font-Weight-Test-KMP](https://github.com/YuKongA/Font_Weight_Test-KMP)
- [Google Fonts](https://fonts.google.com/)

## Star History

<a href="https://star-history.tsinbei.com/#TsinbeiLabs/GoogleSansMax&type=date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://star-history.tsinbei.com/svg?repos=TsinbeiLabs/GoogleSansMax&type=date&theme=dark&legend=top-left" />
    <source media="(prefers-color-scheme: light)" srcset="https://star-history.tsinbei.com/svg?repos=TsinbeiLabs/GoogleSansMax&type=date&legend=top-left" />
    <img alt="Star History Chart" src="https://star-history.tsinbei.com/svg?repos=TsinbeiLabs/GoogleSansMax&type=date&legend=top-left" />
  </picture>
</a>

## License
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FHsukqiLee%2FGoogleSansMax.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2FHsukqiLee%2FGoogleSansMax?ref=badge_large)
