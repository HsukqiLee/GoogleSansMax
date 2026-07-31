## What's New in v1.5.2

- Fix complex combining-character fallback such as `U+25D4 U+032F U+25D4`.
- Put `NotoSansSuper` before the partial `NotoUnicode` fallback so a complete character cluster stays in one font.
- Fix CFF glyph detection by drawing actual outlines instead of reading lazy, undecompiled CharString programs.
- Remove unsafe Unicode block stripping and preserve real base/combining-mark coverage.
- Keep the v1.4.5 emoji punctuation fix for `! , - . : ; ?` without modifying primary or emoji fonts.
- Add regression tests for combining clusters, printable ASCII, generic fallback ordering, and cmap stripping safety.
