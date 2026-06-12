## What's New in v1.3.0

- `0fd55e6` fix(font_fallback): resolve boot timeout and SELinux context for font_fallback.xml overlay
  - CJK entries no longer replaced with VF variants in font_fallback.xml (caused FontListParser hang)
  - Only sans-serif/serif/monospace patched in font_fallback.xml; CJK weight expansion handled by fonts.xml
  - Added sepolicy.rule for init to relabel font_fallback.xml to system_font_fallback_file
  - Added chcon/setfattr during install and repatch for correct SELinux context

## What's New in v1.2.2

- `0f17197` fix: backup reads from mirror/system paths, repatch always starts fresh
- `1ff6d7d` fix: backup XML uses hardcoded paths instead of undefined variables
- `2277d09` refactor(webui): simplify architecture, add italic preview, sliding nav
- `b9752d7` chore: update font manifest [skip ci]
- `001626d` chore: auto-bump version and update JSONs to v1.2.1 [skip ci]
