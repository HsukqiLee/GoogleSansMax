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

"""Strip cmap entries from coverage fonts for specific Unicode block ranges.

Safety principle: only strip codepoints where we KNOW an earlier font in
the fallback chain provides a real glyph.  Coverage fonts (NotoSansSuper,
NotoUnicode, LastResort) include cmap entries for a vast range of
codepoints but map most to empty glyphs (CFF charstrings with program
length 0).  When Android's Minikin renderer finds a cmap hit in one of
these fonts, it stops searching and renders the empty glyph.

The block ranges below are limited to the intersection of:
  (a) blocks where the coverage font has empty glyphs, AND
  (b) blocks where GoogleSansFlex (the first fallback font) has REAL glyphs.

Extending these ranges requires verifying that every codepoint in the
range has a real glyph in a font that appears BEFORE the coverage font
in the fallback chain (fonts_fragment.xml order).
"""
import os
import re
import sys
from fontTools import ttLib

# Only fonts matching these patterns are processed.
COVERAGE_FONT_PATTERNS = [
    r'NotoSansSuper',
    r'NotoUnicode',
    r'LastResort',
]

# Unicode block ranges where GoogleSansFlex (first in chain) provides
# real glyphs for ALL codepoints.  Stripping these from coverage fonts
# is safe because the renderer will find the real glyph in GoogleSansFlex.
BLOCK_RANGES = [
    (0x0020, 0x007E),   # ASCII
    (0x00A0, 0x00FF),   # Latin-1 Supplement
    (0x2000, 0x206F),   # General Punctuation
]

# Precompute flat codepoint set
BLOCK_CODEPOINTS = set()
for lo, hi in BLOCK_RANGES:
    BLOCK_CODEPOINTS.update(range(lo, hi + 1))


def _glyph_has_contours(font, glyph_name):
    """True if glyph has actual drawing instructions."""
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


def _resolve_glyph_name(font, cmap_val, glyph_order):
    if isinstance(cmap_val, str):
        return cmap_val
    if glyph_order and cmap_val < len(glyph_order):
        return glyph_order[cmap_val]
    return None


def _is_coverage(fname):
    return any(re.search(p, fname) for p in COVERAGE_FONT_PATTERNS)


def _strip_font(font):
    """Strip empty-glyph cmap entries for codepoints in BLOCK_CODEPOINTS.
    Returns True if any entry was removed."""
    if 'cmap' not in font:
        return False
    modified = False
    glyph_order = font.getGlyphOrder() if 'glyf' in font else None
    for subtable in font['cmap'].tables:
        if not hasattr(subtable, 'cmap'):
            continue
        to_del = []
        for cp in subtable.cmap:
            if cp not in BLOCK_CODEPOINTS:
                continue
            val = subtable.cmap[cp]
            gname = _resolve_glyph_name(font, val, glyph_order)
            if gname and not _glyph_has_contours(font, gname):
                to_del.append(cp)
        for cp in to_del:
            del subtable.cmap[cp]
            modified = True
    return modified


def strip_font(path):
    """Strip from a single font file (or TTC).  Returns True if modified."""
    if not path.lower().endswith('.ttc'):
        font = ttLib.TTFont(path)
        if _strip_font(font):
            font.save(path)
            return True
        return False

    # TTC
    from fontTools.ttLib import TTCollection
    tc = TTCollection(path)
    modified = False
    n = len(tc.fonts)
    for i in range(n):
        print(f"    [{i + 1}/{n}] Sub-font {i}...", file=sys.stderr)
        if _strip_font(tc.fonts[i]):
            modified = True
    if modified:
        print(f"    Saving TTC...", file=sys.stderr)
        tc.save(path)
    return modified


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
        if not _is_coverage(fname):
            print(f"  Skipped (not coverage): {path}")
            continue
        try:
            if strip_font(path):
                print(f"  Stripped: {path}")
            else:
                print(f"  Skipped (no empty entries): {path}")
        except Exception as e:
            print(f"  ERROR: {path}: {e}")


if __name__ == '__main__':
    main()
