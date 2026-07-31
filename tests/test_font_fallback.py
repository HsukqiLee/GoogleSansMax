import importlib.util
import tempfile
import unittest
from pathlib import Path
from xml.etree import ElementTree

from fontTools import ttLib


ROOT = Path(__file__).resolve().parents[1]


def load_script(name):
    path = ROOT / "scripts" / name
    spec = importlib.util.spec_from_file_location(path.stem, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


stripper = load_script("strip_font_cmap.py")


class FontFallbackTest(unittest.TestCase):
    def test_noto_sans_super_glyphs_are_not_lazily_misclassified(self):
        font = ttLib.TTFont(ROOT / "system/fonts/NotoSansSuper.otf")
        cmap = font.getBestCmap()
        for codepoint in (0x0041, 0x0301, 0x25D4, 0x032F):
            glyph_name = cmap[codepoint]
            char_string = font["CFF "].cff.topDictIndex[0].CharStrings[glyph_name]
            self.assertEqual([], char_string.program)
            self.assertTrue(stripper._glyph_has_contours(font, glyph_name))
        font.close()

    def test_complex_cluster_is_covered_before_partial_unicode_font(self):
        fragment = ElementTree.fromstring(
            "<familyset>"
            + (ROOT / "config/fonts_fragment.xml").read_text(encoding="utf-8")
            + "</familyset>"
        )
        filenames = [
            "".join(font.itertext()).strip()
            for family in fragment.findall("family")
            for font in family.findall("font")
        ]
        self.assertLess(
            filenames.index("NotoSansSuper.otf"),
            filenames.index("NotoUnicode.otf"),
        )

        super_font = ttLib.TTFont(ROOT / "system/fonts/NotoSansSuper.otf")
        super_cmap = super_font.getBestCmap()
        for codepoint in (0x25D4, 0x032F):
            self.assertTrue(
                stripper._glyph_has_contours(super_font, super_cmap[codepoint])
            )
        super_font.close()

    def test_generic_fallback_does_not_include_noto_sans_mono(self):
        fragment = ElementTree.fromstring(
            "<familyset>"
            + (ROOT / "config/fonts_fragment.xml").read_text(encoding="utf-8")
            + "</familyset>"
        )
        filenames = {
            "".join(font.itertext()).strip()
            for family in fragment.findall("family")
            for font in family.findall("font")
        }
        self.assertNotIn("NotoSansMono-VF.ttf", filenames)

    def test_strip_preserves_real_cluster_coverage(self):
        source = ROOT / "system/fonts/NotoSansSuper.otf"
        with tempfile.TemporaryDirectory() as tempdir:
            output = Path(tempdir) / source.name
            output.write_bytes(source.read_bytes())
            before_font = ttLib.TTFont(output)
            before = set(before_font.getBestCmap())
            before_font.close()
            primary = ttLib.TTFont(
                ROOT / "system/fonts/GoogleSansFlex-Regular.ttf"
            )
            safe = stripper._real_codepoints(primary)
            primary.close()

            self.assertTrue(stripper.strip_font(str(output), safe))

            after_font = ttLib.TTFont(output)
            after = after_font.getBestCmap()
            self.assertEqual(
                stripper.PRIMARY_OVERRIDE_CODEPOINTS,
                before - set(after),
            )
            remaining_ascii = set(range(0x20, 0x7F)) - (
                stripper.PRIMARY_OVERRIDE_CODEPOINTS | {0x20}
            )
            for codepoint in remaining_ascii:
                with self.subTest(ascii_codepoint=codepoint):
                    self.assertIn(codepoint, after)
                    self.assertTrue(
                        stripper._glyph_has_contours(
                            after_font, after[codepoint]
                        )
                    )
            self.assertIn(0x0041, after)
            self.assertIn(0x0301, after)
            sequences = (
                (0x25D4, 0x032F),
                (0x0041, 0x1AB0),
                (0x0041, 0x1DC0),
                (0x0041, 0x20D0),
                (0x0041, 0xFE20),
            )
            for sequence in sequences:
                with self.subTest(sequence=sequence):
                    self.assertTrue(set(sequence) <= set(after))
            after_font.close()


if __name__ == "__main__":
    unittest.main()
