# GoogleSansMax

<div align="center">

<a href="README.md">
  <img src="https://img.shields.io/badge/Language-Chinese-blue?style=for-the-badge" alt="Chinese Version">
</a>
<a href="#">
  <img src="https://img.shields.io/badge/Language-English-red?style=for-the-badge" alt="English Version">
</a>

</div>

GoogleSansMax is a highly customized, "Masterpiece" comprehensive Magisk/KernelSU font module. The core objective of this project is to provide the most complete and optimized cross-language font replacement solution for Android, while structurally resolving the widespread pain points of traditional font modules, such as overlay conflicts, missing font weights, and rendering cache bugs.

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

### Weight Implementation Details

**Google Sans Flex (Latin Sans-Serif)**
- Single variable font file with native `wght` axis supporting 1–1000
- Also supports `opsz` (6–144), `wdth` (25–151), `GRAD` (0–100), `slnt` (-10–0)
- fonts.xml declares 100–1000 across 10 standard weight tiers, mapped via `<axis tag="wght" stylevalue="N" />`
- Apps can use `fontVariationSettings` at runtime for any weight (1–1000)

**Latin Serif**
- Noto Serif variable font with `wght` axis supporting 100–900
- Downloaded at CI build time from notofonts.github.io
- All weights mapped via `<axis tag="wght" stylevalue="N" />`
- Weight alias chain: serif-thin(100), serif-light(300), serif-medium(400), serif-semi-bold(500), serif-bold(700), serif-black(900)

**Noto Sans Mono (Latin Monospace)**
- Downloaded at CI build time from Google Fonts
- `wght` axis supports 100–900 (native VF range), out-of-range values auto-clamped

**Noto CJK (Chinese/Japanese/Korean)**
- VF `NotoSansCJK-VF.otf.ttc` covers 100–900, `NotoSerifCJK-VF.otf.ttc` covers 200–900
- CJK Black fonts have internal `usWeightClass=900`, identical to VF axis 900, so weight 1000 is not declared separately
- Languages covered: Japanese (ja), Korean (ko), Simplified Chinese (zh-Hans), Traditional Chinese (zh-Hant), Bopomofo (zh-Bopo)
- All CJK weights use unified `postScriptName`

**Emoji Engine**: Automatically synchronizes the latest upstream resources during build-time, offering options between highly compatible CBDT (Bitmap) and high-definition lossless COLRv1 (Vector) Emoji standards.
- **Rare Character Completion**: Deeply integrates the core code of `UnicodeFontSet` to provide full Unicode character set fallback completion.

### WebUI Font Weight Test

The module includes a built-in font weight test WebUI, accessible via Magisk/KernelSU manager after installation:
- Supports Sans-Serif / Serif / Monospace / CJK full family weight preview
- Supports Simplified Chinese / Traditional Chinese / Japanese / Korean language switching
- Supports custom text testing
- Supports character coverage viewing
- Auto dark/light theme switching

## Technical Analysis & Bug Fix Explanations

During the development of this project, we conducted in-depth research on mainstream font modules on the market (such as `notocjk`, `Google-Sans-Plus`, `MakeFontsGreatAgain`, etc.), and reconstructed the underlying architecture to address their historical legacy issues:

### 1. Resolving the `fonts.xml` Conflict Disaster in Multi-Module Environments
- **Analysis of the Original Issue**: The vast majority of "simple replacement" font modules blindly overwrite the system's `/system/etc/fonts.xml` directly via Magisk's Magic Mount mechanism. When a user installs multiple font modules, the later-loaded module violently overwrites the XML file of the former, causing all previous configurations to fail. Furthermore, this blind overwriting destroys the proprietary font node configurations customized by various phone manufacturers (OEMs) for their UIs.
- **Our Solution**: We have abandoned the practice of statically overwriting the XML. This module utilizes high-precision `sed` dynamic parsing and replacement logic during the installation phase:
  1. First, it performs refined replacement of specific nodes (such as `sans-serif` and `zh-Hans`) on the system's native `fonts.xml`, preserving the OEM's private configurations.
  2. Subsequently, it seamlessly connects with the advanced DOM injection scripts of `UnicodeFontSet` to append complex Unicode fallback nodes to the end of the file.
  All modifications are completed in a unified pipeline during install-time, thereby eliminating the issues of incomplete weights or missing characters caused by inter-module overwrite conflicts from the root.

### 2. Forcing Google Apps to Respect System Fonts (Kill GMS Font)
- **Analysis of the Original Issue**: After successfully replacing the system font with Google Sans, you may notice that first-party Google apps (like Google Discover, Maps, Play Store) continue to use their own fonts, potentially causing CJK weight display anomalies. This is because Google Play Services (GMS) has an internal `FontsProvider` that bypasses system fonts and secretly downloads its own font cache to the `/data/` partition for apps to use.
- **Our Solution**: We have deeply integrated the core interception logic of `killgmsfont`. After booting, the module silently disables the GMS font update service and automatically clears its secretly downloaded font cache directory. Through this mechanism, we forcibly require all official Google apps to fall back to using the underlying system-wide `GoogleSansMax`, ensuring absolute uniformity in font rendering globally (including within the Google ecosystem).

### 3. Firefox Compatibility (Gecko Ignores `lang` Tags)

Firefox's Gecko engine ignores `lang`-tagged CJK families in Android's `fonts.xml` / `font_fallback.xml` when resolving web content fonts (these tags work correctly for other browsers and system UI). Configurations that rely solely on `lang="zh-Hans"` etc. to serve CJK VF fonts are not recognized by Firefox.

**Solution**: A lang-less global CJK fallback entry is appended to both `fonts.xml` and `font_fallback.xml`, referencing the system's static `NotoSansCJK-Regular.ttc` (non-VF, no axis tags). This ensures Gecko can resolve CJK characters without relying on language-tagged families.


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

## 🛠 How to Create Your Own Font Module Based on This Repo

This project is set as a Public Template. You can Fork this repository to quickly build your own Magisk / KernelSU font module, while enjoying the advanced XML parsing/injection technology and hot-update mechanism of this project.

### Customization Guide

1. **Replace Font Files**
   - Place your own font files into the `system/fonts/` directory.
   - **The Easiest Setup**: Rename your font files to match the existing filenames (e.g., `GoogleSansFlex-Regular.ttf` or `NotoSansCJK-VF.otf.ttc`) and overwrite them.
   - **Note**: This project defaults to using Variable Fonts (`wght` axis) for weight mapping. If you want to use multiple static font files for different weights, you need to modify the `generate_xxx_xml` functions in `customize.sh`.

2. **Update Module Properties**
   - Edit `module.prop` in the root directory: Change `id`, `name`, `version`, `versionCode`, `author`, and `description`. **Important:** Ensure your `id` is unique to avoid conflicts with other modules.

3. **Modify Build Scripts (Optional)**
   - This project uses GitHub Actions for automated builds. If you change the source of your fonts, modify the download links and build logic in `.github/workflows/release.yml`.
   - If you changed the font filenames, remember to update the corresponding filenames and weight generation logic in `customize.sh` and `action.sh`.

4. **Publish Your Release**
   - Simply publish a new Tag on the GitHub Releases page to trigger the Actions build and automatically package your ZIP file.

## Credits
- [simonsmh / notocjk](https://github.com/simonsmh/notocjk)
- [Magisk-Modules-Alt-Repo / Google-Sans-Plus](https://github.com/Magisk-Modules-Alt-Repo/Google-Sans-Plus)
- [Losketch / UnicodeFontSet-magisk-module](https://github.com/Losketch/UnicodeFontSet-magisk-module)
- [MrCarb0n / killgmsfont](https://github.com/MrCarb0n/killgmsfont)
- [Numbersf / MakeFontsGreatAgain](https://github.com/Numbersf/MakeFontsGreatAgain)
- [YuKongA / Font-Weight-Test](https://github.com/YuKongA/Font-Weight-Test) — WebUI font weight test reference
- [YuKongA / Font-Weight-Test-KMP](https://github.com/YuKongA/Font_Weight_Test-KMP) — KMP cross-platform font weight test reference
- [**Google Fonts**](https://fonts.google.com/)
