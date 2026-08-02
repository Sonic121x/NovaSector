// i18n: CJK pixel font for maptext (balloon alerts, screentips, runechat, etc.)
//
// The core maptext fonts (Grand9K Pixel / Pixellari / TinyUnicode / Spess Font) only
// contain Latin glyphs. When Chinese text is rendered in maptext, BYOND falls back to a
// system font and renders it soft/blurry. We bundle a pixel CJK font and make it the
// PRIMARY maptext font (interface/skin.dmf) so the CJK renders in it.
//
// Fusion Pixel 12px (OFL-1.1, https://github.com/TakWolf/fusion-pixel-font), zh_hans,
// monospaced. Contains BOTH CJK and Latin glyphs. License: modular_nova/modules/i18n/fonts/OFL.txt
//
// SIZING (the crucial part — pixel fonts only render crisp at their native px or integer
// multiples). BYOND maptext takes font-size in PT and renders em_px = pt * 4/3 (96dpi):
// 6pt->8px, 9pt->12px, 12pt->16px, 18pt->24px. This font's design grid is 12px
// (unitsPerEm=1200, 100 units/px), so it is pixel-perfect at em_px = 12px (9pt) and at
// integer multiples (24px = 18pt). USE 9pt in skin.dmf for 1:1 crisp CJK.
//   - Do NOT use explicit px font-size: BYOND anti-aliases px maptext -> blurry (it wants pt).
//   - The earlier 8px variant was crisp only at 6pt, but 8px CJK is too few pixels (rough);
//     12px@9pt gives clear, legible CJK.
//
// LINE-HEIGHT (skin.dmf): upstream sets `.subcontext { line-height: 0.75 }` for the screentip
// action-hints, which is safe for TinyUnicode — its glyphs are far shorter than its em box, so a
// 0.75 line box still clears them. CJK glyphs fill the **whole** em, so 0.75 makes consecutive
// hint lines bite into each other (玩家看到的「快捷键提示挤在一起」). Any class that can render
// Chinese needs line-height >= 1.0. Keep it an integer multiple of the design grid too — pixel
// fonts blur on fractional line boxes.
//
// NOTE: BYOND maptext does NOT do per-glyph fallback across a comma-separated font-family
// list — it renders glyphs from the FIRST font and substitutes a hardcoded system font for
// any the first font lacks (the 2nd+ entries are ignored). So this font must be FIRST; since
// it has Latin glyphs too, all maptext (CJK + Latin) renders in it.
/datum/font/fusion_pixel_12px
	name = "Fusion Pixel 12px Mono zh_hans"
	font_family = 'modular_nova/modules/i18n/fonts/fusion_pixel_12px_zh_hans.ttf'

// Smaller 8px variant (design 8px → crisp at 6pt = 8px em). Used for the "small" maptext
// classes (.maptext runechat/balloon speech, .subcontext screentip action-hints, .small,
// .italics) so they're genuinely smaller than the 12px screentip name (.context). 8px CJK
// has fewer pixels (rougher) but reads as small secondary text. Crisp ONLY at 6pt/12pt/18pt.
/datum/font/fusion_pixel_8px
	name = "Fusion Pixel 8px Mono zh_hans"
	font_family = 'modular_nova/modules/i18n/fonts/fusion_pixel_8px_zh_hans.ttf'

// 10px variant (design 10px → crisp at 7.5pt = 10px em, and at 15pt = 20px). Used for the
// small maptext that was previously 8px@6pt (balloon alerts .maptext, screentip action-hints
// .subcontext) to make them a bit larger / clearer than the 8px glyphs, while still smaller
// than the 12px screentip name (.context @ 9pt). Crisp ONLY at 7.5pt / 15pt.
/datum/font/fusion_pixel_10px
	name = "Fusion Pixel 10px Mono zh_hans"
	font_family = 'modular_nova/modules/i18n/fonts/fusion_pixel_10px_zh_hans.ttf'
