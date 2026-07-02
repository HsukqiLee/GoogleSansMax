# Copyright (C) 2025 Hsukqi Lee <https://github.com/HsukqiLee>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

"""Strip cmap entries from coverage fonts for blocks with real glyphs upstream.

Coverage fonts (NotoSansSuper, NotoUnicode, LastResort, etc.) include cmap
entries for a vast range of codepoints, but map most to empty glyphs (CFF
charstrings with program length 0). When Android's Minikin renderer finds
a cmap hit in one of these fonts, it stops searching and renders the empty
glyph instead of continuing to a font with real drawing instructions.

The fix: for codepoints where an EARLIER font in the fallback chain has a
real glyph, strip the coverage font's cmap entry so the renderer finds the
real glyph.  For codepoints without a real upstream glyph, we leave the
coverage font entry in place to avoid falling through to the Last Resort
font (which shows a box-with-glyph-ID symbol).

This script only operates on fonts whose filename matches one of the
patterns in COVERAGE_FONT_PATTERNS, to avoid modifying real fonts.
"""
import os
import re
import sys
from fontTools import ttLib

# Fonts matching any of these regex patterns are considered "coverage" fonts
# whose empty cmap entries should be stripped.
COVERAGE_FONT_PATTERNS = [
    r'NotoSansSuper',
    r'NotoUnicode',
    r'LastResort',
]

# Unicode block ranges to strip from coverage fonts.
# ONLY include blocks where an EARLIER font in the fallback chain is
# known to have real glyphs for ALL codepoints in the range.
BLOCK_RANGES = [
    # --- Basic Latin / ASCII (GoogleSansFlex has real glyphs for all) ---
    (0x0020, 0x007E),
    # --- Latin-1 Supplement (GoogleSansFlex ~ 00A0-00FF) ---
    (0x00A0, 0x00FF),
    # --- General Punctuation (spaces, dashes, quotes; in GoogleSansFlex) ---
    (0x2000, 0x206F),
]

BLOCK_CODEPOINTS = set()
for lo, hi in BLOCK_RANGES:
    BLOCK_CODEPOINTS.update(range(lo, hi + 1))


def _glyph_has_contours(font, glyph_name):
    if not glyph_name:
        return False
    if 'CFF ' in font or 'CFF2' in font:
        top_key = 'CFF2' if 'CFF2' in font else 'CFF '
        td = font[top_key].cff.topDictIndex[0]
        try:
            cs = td.CharStrings[glyph_name]
            return len(cs.program) > 0
        except KeyError:
            return False
    if 'glyf' in font:
        try:
            glyph = font['glyf'][glyph_name]
        except (KeyError, TypeError):
            return False
        if glyph.numberOfContours > 0:
            return True
        if getattr(glyph, 'components', None):
            return True
        return False
    return True


def _is_empty_glyph(font, glyph_name):
    return not _glyph_has_contours(font, glyph_name)


def _resolve_glyph_name(font, cmap_val, glyph_order):
    if isinstance(cmap_val, str):
        return cmap_val
    if glyph_order and cmap_val < len(glyph_order):
        return glyph_order[cmap_val]
    return None


def _strip_font(font):
    if 'cmap' not in font:
        return False
    modified = False
    glyph_order = font.getGlyphOrder() if 'glyf' in font else None
    for subtable in font['cmap'].tables:
        if not hasattr(subtable, 'cmap'):
            continue
        for cp in BLOCK_CODEPOINTS:
            if cp not in subtable.cmap:
                continue
            glyph_name = _resolve_glyph_name(font, subtable.cmap[cp], glyph_order)
            if _is_empty_glyph(font, glyph_name):
                del subtable.cmap[cp]
                modified = True
    return modified


def strip_font(path):
    ext = os.path.splitext(path)[1].lower()
    if ext != '.ttc':
        font = ttLib.TTFont(path)
        if _strip_font(font):
            font.save(path)
            return True
        return False
    from fontTools.ttLib import TTCollection
    tc = TTCollection(path)
    modified = False
    n = len(tc.fonts)
    for i in range(n):
        print(f"    [{i+1}/{n}] Processing sub-font {i}...", file=sys.stderr)
        if _strip_font(tc.fonts[i]):
            modified = True
    if modified:
        print(f"    Saving modified TTC...", file=sys.stderr)
        tc.save(path)
    return modified


def _is_coverage_font(filename):
    for pat in COVERAGE_FONT_PATTERNS:
        if re.search(pat, filename):
            return True
    return False


def main():
    if len(sys.argv) < 2:
        print("Usage: python strip_font_cmap.py <path> [path2 ...]")
        print("       <path> can be a single font file or a directory")
        print()
        print("Only coverage fonts (matching COVERAGE_FONT_PATTERNS) are processed.")
        sys.exit(1)

    targets = []
    for arg in sys.argv[1:]:
        if os.path.isdir(arg):
            for f in sorted(os.listdir(arg)):
                if f.lower().endswith(('.ttf', '.otf', '.ttc')):
                    targets.append((os.path.join(arg, f), f))
        else:
            targets.append((arg, os.path.basename(arg)))

    for path, fname in targets:
        if not _is_coverage_font(fname):
            print(f"  Skipped (not a coverage font): {path}")
            continue
        try:
            if strip_font(path):
                print(f"  Stripped: {path}")
            else:
                print(f"  Skipped (no matching entries): {path}")
        except Exception as e:
            print(f"  ERROR: {path}: {e}")


if __name__ == '__main__':
    main()
