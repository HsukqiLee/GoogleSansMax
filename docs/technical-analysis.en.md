# Technical Analysis & Bug Fix Explanations

During the development of this project, we conducted in-depth research on mainstream font modules on the market (such as `notocjk`, `Google-Sans-Plus`, `MakeFontsGreatAgain`, etc.), and reconstructed the underlying architecture to address their historical legacy issues:

## 1. Resolving the `fonts.xml` Conflict Disaster in Multi-Module Environments

**Analysis of the Original Issue**: The vast majority of "simple replacement" font modules blindly overwrite the system's `/system/etc/fonts.xml` directly via Magisk's Magic Mount mechanism. When a user installs multiple font modules, the later-loaded module violently overwrites the XML file of the former, causing all previous configurations to fail. Furthermore, this blind overwriting destroys the proprietary font node configurations customized by various phone manufacturers (OEMs) for their UIs.

**Our Solution**: We have abandoned the practice of statically overwriting the XML. This module utilizes high-precision `sed` dynamic parsing and replacement logic during the installation phase:
1. First, it performs refined replacement of specific nodes (such as `sans-serif` and `zh-Hans`) on the system's native `fonts.xml`, preserving the OEM's private configurations.
2. Subsequently, it seamlessly connects with the advanced DOM injection scripts of `UnicodeFontSet` to append complex Unicode fallback nodes to the end of the file.

All modifications are completed in a unified pipeline during install-time, thereby eliminating the issues of incomplete weights or missing characters caused by inter-module overwrite conflicts from the root.

## 2. Forcing Google Apps to Respect System Fonts (Kill GMS Font)

**Analysis of the Original Issue**: After successfully replacing the system font with Google Sans, you may notice that first-party Google apps (like Google Discover, Maps, Play Store) continue to use their own fonts, potentially causing CJK weight display anomalies. This is because Google Play Services (GMS) has an internal `FontsProvider` that bypasses system fonts and secretly downloads its own font cache to the `/data/` partition for apps to use.

**Our Solution**: We have deeply integrated the core interception logic of `killgmsfont`. After booting, the module silently disables the GMS font update service and automatically clears its secretly downloaded font cache directory. Through this mechanism, we forcibly require all official Google apps to fall back to using the underlying system-wide `GoogleSansMax`, ensuring absolute uniformity in font rendering globally (including within the Google ecosystem).

## 3. Firefox Compatibility (Gecko Ignores `lang` Tags)

Firefox's Gecko engine ignores `lang`-tagged CJK families in Android's `fonts.xml` / `font_fallback.xml` when resolving web content fonts (these tags work correctly for other browsers and system UI). Configurations that rely solely on `lang="zh-Hans"` etc. to serve CJK VF fonts are not recognized by Firefox.

**Solution**: A lang-less global CJK fallback entry is appended to both `fonts.xml` and `font_fallback.xml`, referencing the system's static `NotoSansCJK-Regular.ttc` (non-VF, no axis tags). This ensures Gecko can resolve CJK characters without relying on language-tagged families.
