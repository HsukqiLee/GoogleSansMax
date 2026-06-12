## What's New in v1.3.0

- `7214979` fix(webui): MD3 polish — italic, slider, tabs, charset
  - Enable italic display for Mono and CJK weight grids
  - Fix compare tab showing `[object HTMLSpanElement]` instead of Italic chip
  - Redesign slider to proper MD3: custom track with fill gradient + 20px circular thumb
  - Make tabs scrollable instead of equal-width stretch on narrow screens
  - Fix charset tab default active chip not matching (`latin` vs `Latin`)
  - Style CJK Sample separator as MD3 overline label
- `64b7341` fix(webui): pass app arg to render functions + remove stray max= assignment
- `4474d9f` fix(webui): remove double-blue on active nav + add slider labels
- `6eae87a` fix: remove broken monospace italic entries (NotoSansMono has no slant axis)
- `a7d9d56` fix: re-inject Unicode fragment on repatch + preserve config/
- `54df257` fix: replace broken NotoSerif/NotoSansMono VF fonts + fix italic entries
- `0fd55e6` fix(font_fallback): resolve boot timeout and SELinux context for font_fallback.xml overlay
  - CJK entries no longer replaced with VF variants in font_fallback.xml (caused FontListParser hang)
  - Only sans-serif/serif/monospace patched in font_fallback.xml; CJK weight expansion handled by fonts.xml
  - Added sepolicy.rule for init to relabel font_fallback.xml to system_font_fallback_file
  - Added chcon/setfattr during install and repatch for correct SELinux context
- `c9dfc5a` fix: patch font_fallback.xml (Android 17 reads it instead of fonts.xml)

## What's New in v1.2.2

- `0f17197` fix: backup reads from mirror/system paths, repatch always starts fresh
- `1ff6d7d` fix: backup XML uses hardcoded paths instead of undefined variables
- `2277d09` refactor(webui): simplify architecture, add italic preview, sliding nav
- `b9752d7` chore: update font manifest [skip ci]
- `001626d` chore: auto-bump version and update JSONs to v1.2.1 [skip ci]
