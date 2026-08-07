import importlib.util
import os
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace
from xml.etree import ElementTree

import uharfbuzz
from fontTools import ttLib


ROOT = Path(__file__).resolve().parents[1]
MONO_FONT = Path(
    os.environ.get(
        "GSM_MONO_FONT",
        ROOT / "system/fonts/NotoSansMono-VF.ttf",
    )
)


def load_script(name):
    path = ROOT / "scripts" / name
    spec = importlib.util.spec_from_file_location(path.stem, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


stripper = load_script("strip_font_cmap.py")
symbol_builder = load_script("build_symbol_combining_compat.py")
auditor = load_script("audit_combining_fallback.py")


class FontFallbackTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tempdir = tempfile.TemporaryDirectory()
        temp = Path(cls.tempdir.name)
        cls.symbol_compat = temp / "GoogleSansMaxSymbolCombiningCompat.otf"
        symbol_builder.build_font(
            ROOT / "system/fonts/NotoSansSuper.otf",
            MONO_FONT,
            ROOT / "system/fonts/GoogleSansFlex-Regular.ttf",
            cls.symbol_compat,
        )

    @classmethod
    def tearDownClass(cls):
        cls.tempdir.cleanup()

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

    def test_last_resort_is_the_terminal_injected_fallback(self):
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
        self.assertEqual("LastResort-Regular.ttf", filenames[-1])
        self.assertLess(
            filenames.index("NotoSansCJK-Regular.ttc"),
            filenames.index("LastResort-Regular.ttf"),
        )

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

    def test_fragment_registers_the_bundled_emoji_font(self):
        fragment = ElementTree.fromstring(
            "<familyset>"
            + (ROOT / "config/fonts_fragment.xml").read_text(encoding="utf-8")
            + "</familyset>"
        )
        emoji_families = [
            family
            for family in fragment.findall("family")
            if family.get("lang") == "und-Zsye"
        ]
        self.assertEqual(1, len(emoji_families))
        filenames = {
            "".join(font.itertext()).strip()
            for font in emoji_families[0].findall("font")
        }
        self.assertEqual({"NotoColorEmoji.ttf"}, filenames)
        self.assertNotIn(
            "NotoEmoji-Regular.ttf",
            (ROOT / "config/fonts_fragment.xml").read_text(encoding="utf-8"),
        )

    def test_bundled_emoji_font_composes_representative_sequences(self):
        emoji_font = Path(
            os.environ.get(
                "GSM_EMOJI_FONT",
                ROOT / "system/fonts/NotoColorEmoji.ttf",
            )
        )
        if not emoji_font.is_file():
            self.skipTest("NotoColorEmoji.ttf is downloaded per release variant")

        face = uharfbuzz.Face(emoji_font.read_bytes())
        font = uharfbuzz.Font(face)
        font.scale = (face.upem, face.upem)
        sequences = (
            "\u2764\ufe0f",  # emoji presentation
            "1\ufe0f\u20e3",  # keycap
            "\U0001f469\u200d\U0001f4bb",  # ZWJ sequence
            "\U0001f1fa\U0001f1f8",  # regional-indicator flag
            "\U0001f44d\U0001f3fd",  # skin tone
            "\U0001f3f4\U000e0067\U000e0062\U000e0065"
            "\U000e006e\U000e0067\U000e007f",  # tag flag
        )
        for sequence in sequences:
            with self.subTest(sequence=sequence):
                buffer = uharfbuzz.Buffer()
                buffer.add_str(sequence)
                buffer.guess_segment_properties()
                uharfbuzz.shape(font, buffer)
                self.assertEqual(1, len(buffer.glyph_infos))
                self.assertNotEqual(0, buffer.glyph_infos[0].codepoint)

    def test_priority_fragment_contains_only_symbol_compat(self):
        fragment = ElementTree.fromstring(
            "<familyset>"
            + (ROOT / "config/fonts_priority_fragment.xml").read_text(
                encoding="utf-8"
            )
            + "</familyset>"
        )
        filenames = [
            "".join(font.itertext()).strip()
            for family in fragment.findall("family")
            for font in family.findall("font")
        ]
        self.assertEqual(
            ["GoogleSansMaxSymbolCombiningCompat.otf"], filenames
        )

    def test_symbol_compat_is_narrow_and_has_real_anchors(self):
        font = ttLib.TTFont(self.symbol_compat)
        cmap = font.getBestCmap()
        self.assertFalse(set(range(0x80)) & set(cmap))
        self.assertIn(0x25D4, cmap)
        self.assertIn(0x032F, cmap)
        self.assertEqual({"GDEF", "GPOS"}, {tag for tag in ("GDEF", "GPOS") if tag in font})
        font.close()

        face = auditor.FontFace(self.symbol_compat, 0, 0)
        pairs = face.codepoint_mark_pairs()
        self.assertGreater(len({base for base, _ in pairs}), 100)
        self.assertGreater(len({mark for _, mark in pairs}), 150)
        self.assertGreater(len(pairs), 20000)
        self.assertTrue(face.has_mark_anchor(0x25D4, 0x032F))
        standalone = face.shape("\u25D4")
        combined = face.shape("\u25D4\u032F")
        self.assertEqual(standalone[0][0].codepoint, combined[0][0].codepoint)
        self.assertEqual(standalone[0][1].x_advance, sum(item[1].x_advance for item in combined))
        self.assertEqual([0, 0], [item[0].cluster for item in combined])
        self.assertNotEqual(0, combined[1][1].x_offset)
        base_bounds = face.glyph_bounds(combined[0][0].codepoint)
        mark_bounds = face.glyph_bounds(combined[1][0].codepoint)
        base_center_x = (base_bounds[0] + base_bounds[2]) / 2
        mark_center_x = (
            combined[0][1].x_advance
            + combined[1][1].x_offset
            + (mark_bounds[0] + mark_bounds[2]) / 2
        )
        mark_center_y = (
            combined[1][1].y_offset
            + (mark_bounds[1] + mark_bounds[3]) / 2
        )
        self.assertGreater(mark_center_x, base_center_x + 300)
        self.assertLess(mark_center_y, base_bounds[1])

    def test_strip_preserves_real_cluster_coverage(self):
        source = ROOT / "system/fonts/NotoSansSuper.otf"
        if os.environ.get("GSM_FINAL_FONTS") == "1":
            font = ttLib.TTFont(source)
            cmap = font.getBestCmap()
            self.assertFalse(stripper.PRIMARY_OVERRIDE_CODEPOINTS & set(cmap))
            for sequence in (
                (0x25D4, 0x032F),
                (0x0041, 0x1AB0),
                (0x0041, 0x1DC0),
                (0x0041, 0x20D0),
                (0x0041, 0xFE20),
            ):
                with self.subTest(sequence=sequence):
                    self.assertTrue(set(sequence) <= set(cmap))
            font.close()
            return

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

    def test_emoji_provider_requires_real_flag_ligatures(self):
        cmap = {
            codepoint: f"ri{codepoint:X}"
            for codepoint in stripper.REGIONAL_INDICATOR_CODEPOINTS
        }
        ligatures = {}
        for first, second in stripper.FLAG_TEST_SEQUENCES:
            ligatures.setdefault(cmap[first], []).append(
                SimpleNamespace(
                    Component=[cmap[second]],
                    LigGlyph=f"flag{first:X}{second:X}",
                )
            )
        lookup = SimpleNamespace(
            LookupType=4,
            SubTable=[SimpleNamespace(ligatures=ligatures)],
        )
        gsub = SimpleNamespace(
            table=SimpleNamespace(
                LookupList=SimpleNamespace(Lookup=[lookup])
            )
        )

        class FakeFont(dict):
            def getBestCmap(self):
                return cmap

        font = FakeFont(GSUB=gsub)
        self.assertTrue(stripper._supports_flag_sequences(font))

        ligatures[cmap[stripper.FLAG_TEST_SEQUENCES[0][0]]] = []
        self.assertFalse(stripper._supports_flag_sequences(font))

    def test_sequence_override_can_strip_real_glyphs_narrowly(self):
        source = ROOT / "system/fonts/NotoSansSuper.otf"
        with tempfile.TemporaryDirectory() as tempdir:
            output = Path(tempdir) / source.name
            output.write_bytes(source.read_bytes())

            self.assertTrue(
                stripper.strip_font(
                    str(output),
                    forced_codepoints={0x0041},
                )
            )

            font = ttLib.TTFont(output)
            cmap = font.getBestCmap()
            self.assertNotIn(0x0041, cmap)
            self.assertIn(0x0042, cmap)
            font.close()

    def test_flag_overrides_apply_to_every_non_emoji_font(self):
        for filename in (
            "NotoUnicode.otf",
            "KreativeSquare.ttf",
            "LastResort-Regular.ttf",
        ):
            with self.subTest(filename=filename):
                self.assertEqual(
                    stripper.REGIONAL_INDICATOR_CODEPOINTS,
                    stripper._emoji_sequence_overrides(filename, True),
                )
        self.assertFalse(
            stripper._emoji_sequence_overrides(
                stripper.EMOJI_PROVIDER_FONT, True
            )
        )
        self.assertFalse(
            stripper._emoji_sequence_overrides(
                "SomeUnrelatedFont.ttf", True
            )
        )
        self.assertFalse(
            stripper._emoji_sequence_overrides("KreativeSquare.ttf", False)
        )

    def test_apple_private_use_codepoint_reaches_logo_font(self):
        self.assertEqual(
            frozenset({0xF8FF}),
            stripper._font_codepoint_overrides("NotoUnicode.otf"),
        )
        self.assertFalse(
            stripper._font_codepoint_overrides("KreativeSquare.ttf")
        )

        source = Path(
            os.environ.get(
                "GSM_NOTO_UNICODE_FONT",
                ROOT / "system/fonts/NotoUnicode.otf",
            )
        )
        if not source.is_file():
            self.skipTest("NotoUnicode.otf is downloaded during release builds")

        if os.environ.get("GSM_FINAL_FONTS") == "1":
            font = ttLib.TTFont(source)
            self.assertNotIn(0xF8FF, font.getBestCmap())
            font.close()
            return

        with tempfile.TemporaryDirectory() as tempdir:
            output = Path(tempdir) / source.name
            output.write_bytes(source.read_bytes())
            before = ttLib.TTFont(output)
            self.assertIn(0xF8FF, before.getBestCmap())
            before.close()

            self.assertTrue(
                stripper.strip_font(
                    str(output),
                    forced_codepoints=stripper._font_codepoint_overrides(
                        output.name
                    ),
                )
            )

            after = ttLib.TTFont(output)
            self.assertNotIn(0xF8FF, after.getBestCmap())
            after.close()


if __name__ == "__main__":
    unittest.main()
