# Bundled fonts

This app bundles static instances of two open-source Google Fonts families so `google_fonts` never needs to fetch font files over the network at runtime:

- **Inter** (Regular/Medium/SemiBold/Italic) — © The Inter Project Authors, licensed under the SIL Open Font License 1.1. Full license text: `OFL-Inter.txt` in this folder, or https://github.com/google/fonts/blob/main/ofl/inter/OFL.txt
- **Playfair Display** (Regular/Medium/SemiBold/Italic) — © Copyright 2016 The Playfair Display Project Authors, licensed under the SIL Open Font License 1.1. Full license text: https://github.com/google/fonts/blob/main/ofl/playfairdisplay/OFL.txt

Both families are distributed upstream by Google Fonts as variable fonts. These `.ttf` files are static-weight instances generated from the official upstream variable fonts using `fonttools varLib.instancer`, so the rendered glyphs are identical to what `google_fonts` would otherwise have downloaded at runtime for the same family/weight/style.

Do not replace these with different font families — `lib/theme.dart` and the app's `GoogleFonts.inter()` / `GoogleFonts.playfairDisplay()` calls expect exactly these families and weights to be present locally.
