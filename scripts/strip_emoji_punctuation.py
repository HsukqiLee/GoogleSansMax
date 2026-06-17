"""Strip ASCII punctuation cmap entries from Unicode fallback fonts.

Some Unicode coverage fonts (e.g. NotoUnicode.otf) include cmap entries
for basic ASCII punctuation characters ( - : ; ! ? . , ) but map them to
empty glyphs (CFF charstrings with program length 0).

When Android's Minikin renderer renders text like "emoji-", it finds the
punctuation in these fallback fonts (cmap hit) and does NOT fall back
to the primary text font (GoogleSansFlex), resulting in an empty box.

This script removes those cmap entries, forcing the renderer to properly
fall back to the primary text font for these basic punctuation characters.
"""
import os
import sys
from fontTools import ttLib

# ASCII punctuation that should always come from the primary text font,
# not from Unicode coverage fallback fonts.
PUNCTUATION_CODEPOINTS = {
    0x0021,  # !
    0x002C,  # ,
    0x002D,  # - (hyphen-minus)
    0x002E,  # .
    0x003A,  # :
    0x003B,  # ;
    0x003F,  # ?
}


def strip_punctuation_from_font(path):
    font = ttLib.TTFont(path)
    modified = False

    for subtable in font['cmap'].tables:
        if hasattr(subtable, 'cmap'):
            for cp in list(PUNCTUATION_CODEPOINTS):
                if cp in subtable.cmap:
                    del subtable.cmap[cp]
                    modified = True

    if modified:
        font.save(path)
        return True
    return False


def main():
    if len(sys.argv) < 2:
        print("Usage: python strip_emoji_punctuation.py <path> [path2 ...]")
        print("       <path> can be a single font file or a directory")
        sys.exit(1)

    targets = []
    for arg in sys.argv[1:]:
        if os.path.isdir(arg):
            for f in os.listdir(arg):
                if f.lower().endswith(('.ttf', '.otf', '.ttc')):
                    targets.append(os.path.join(arg, f))
        else:
            targets.append(arg)

    for path in targets:
        try:
            if strip_punctuation_from_font(path):
                print(f"  Stripped: {path}")
            else:
                print(f"  Skipped (no matching entries): {path}")
        except Exception as e:
            print(f"  ERROR: {path}: {e}")


if __name__ == '__main__':
    main()
