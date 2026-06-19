# GoogleSansMax

<div align="center">

<a href="README.md">
  <img src="https://img.shields.io/badge/Language-Chinese-blue?style=for-the-badge" alt="Chinese Version">
</a>
<a href="#">
  <img src="https://img.shields.io/badge/Language-English-red?style=for-the-badge" alt="English Version">
</a>

</div>

GoogleSansMax is a highly customized, comprehensive Magisk/KernelSU font module. The core objective of this project is to provide the most complete and optimized cross-language font replacement solution for Android, while structurally resolving the widespread pain points of traditional font modules, such as overlay conflicts, missing font weights, and rendering cache bugs.

## Font Coverage & Weight Support

### Overview

| Category | Font Family | Font File(s) | Weight Range | Styles |
|---|---|---|---|---|
| **Latin Sans-Serif** | sans-serif | GoogleSansFlex-Regular.ttf | **100–1000** | normal + italic |
| **Latin Serif** | serif | NotoSerif-VF.ttf | **100–900** | normal + italic |
| **Latin Monospace** | monospace | NotoSansMono-VF.ttf | **100–1000** | normal + italic |
| **CJK Sans-Serif** (ja/ko/zh-Hans/zh-Hant/zh-Bopo) | sans-serif | NotoSansCJK-VF.otf.ttc | **100–900** | normal |
| **CJK Serif** (ja/ko/zh-Hans/zh-Hant/zh-Bopo) | serif (fallbackFor) | NotoSerifCJK-VF.otf.ttc | **200–900** | normal |
| **CJK Monospace** (ja/ko/zh-Hans/zh-Hant/zh-Bopo) | monospace | NotoSansCJK-VF.otf.ttc | **100–900** | normal |
| **Hentaigana** | ja fallback | NotoSerifHentaigana.ttf | **100–1000** | normal |

See [docs/weight-implementation.en.md](docs/weight-implementation.en.md) for detailed weight implementation information.

### WebUI Font Weight Test

The module includes a built-in font weight test WebUI, accessible via Magisk/KernelSU manager after installation:
- Supports Sans-Serif / Serif / Monospace / CJK full family weight preview
- Supports Simplified Chinese / Traditional Chinese / Japanese / Korean language switching
- Supports custom text testing
- Supports character coverage viewing
- Auto dark/light theme switching

## Build Variants and Downloads

This repository uses GitHub Actions for automated matrix building, generating three variant branches upon each Release:

1. **GoogleSansMax-Core.zip**
   - Core Version: Includes only Google Sans and Noto CJK. Lightweight, with no extra burden.
2. **GoogleSansMax-Unicode-CBDT.zip**
   - Compatibility Version: Core + Full Unicode Completion + NotoColorEmoji (CBDT bitmap format).
   - Highly compatible with legacy systems (Android 4.4+), ensuring modern Emojis display on all older devices.
3. **GoogleSansMax-Unicode-COLRv1.zip**
   - Vector Version: Core + Full Unicode Completion + Noto-COLRv1 (COLRv1 vector format).
   - Utilizes next-generation lossless vector Emojis, remaining undistorted regardless of scaling (limited to Android 13+ systems supporting this feature).

## Automated Sync Mechanism

This repository is configured with a GitHub Actions automated workflow. Every week, it automatically pulls the latest rare character and Unicode data resources from the upstream `UnicodeFontSet-magisk-module` repository. When an update is detected, the bot automatically commits the changes and triggers a new Release build, ensuring the character library included in this module remains at the forefront of the industry.

## Installation

1. Go to the [Releases](#) page and download the version that suits you.
2. Flash it via a manager like Magisk or KernelSU.
3. Reboot your device.

## Documentation

- [**Technical Analysis & Bug Fix Explanations**](docs/technical-analysis.en.md) — Multi-module fonts.xml conflict resolution, Kill GMS Font mechanism, Firefox compatibility
- [**How to Create Your Own Font Module**](docs/customization-guide.en.md) — Font type identification, scenario-based replacement guide, XML generation logic modification, publishing workflow

## Credits
- [simonsmh / notocjk](https://github.com/simonsmh/notocjk)
- [Magisk-Modules-Alt-Repo / Google-Sans-Plus](https://github.com/Magisk-Modules-Alt-Repo/Google-Sans-Plus)
- [Losketch / UnicodeFontSet-magisk-module](https://github.com/Losketch/UnicodeFontSet-magisk-module)
- [MrCarb0n / killgmsfont](https://github.com/MrCarb0n/killgmsfont)
- [Numbersf / MakeFontsGreatAgain](https://github.com/Numbersf/MakeFontsGreatAgain)
- [YuKongA / Font-Weight-Test](https://github.com/YuKongA/Font-Weight-Test) — WebUI font weight test reference
- [YuKongA / Font-Weight-Test-KMP](https://github.com/YuKongA/Font_Weight_Test-KMP) — KMP cross-platform font weight test reference
- [**Google Fonts**](https://fonts.google.com/)
