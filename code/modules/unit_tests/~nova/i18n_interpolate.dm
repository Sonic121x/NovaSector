/// `lang_interpolate`（LANG 的占位符填充，modular_nova/modules/i18n/code/runtime.dm）的行为测试。
///
/// 守的核心是**实参自吞**：旧实现按序 `replacetext("{0}")`、`replacetext("{1}")`…，于是**上一个
/// 实参写进串里的内容会被下一轮当成模板再扫一遍**。只要某个实参的值里恰好含 `{1}` —— 纸张文本、
/// 玩家起的物品名、任何玩家可控串都做得到 —— 它就会被后一个实参顶掉，玩家看到一句错乱的话。
/// 现改为单趟扫描：实参一旦写进输出就不再参与匹配。
///
/// 其余几条锁住单趟扫描不该改变的既有行为：越界占位符原样保留、非 `{N}` 花括号按字面处理、
/// 重复占位符各自填充、无实参/无占位符直接返回。
///
/// **实参一律用生造词**（Zxqv 系，同 i18n_template_match 的做法）：locale≠en 时 lang_interpolate
/// 会对文本实参跑 lang_localize_arg，真实英文词（"stick"/"tail"）在真目录或伪 locale 下会被译掉，
/// 断言就成了「测目录内容」而不是「测填充逻辑」。生造词在任何 locale 下都恒等返回。
/datum/unit_test/i18n_interpolate

/datum/unit_test/i18n_interpolate/Run()
	// ① 实参自吞（本次修复的回归点）：第一个实参的值里含 `{1}`，绝不能被第二个实参替换掉。
	TEST_ASSERT_EQUAL( \
		lang_interpolate("{0} and {1}", list("{1}", "Zxqv")), \
		"{1} and Zxqv", \
		"实参里的 {1} 被后一个实参顶掉了 —— 单趟扫描失效")

	// ② 实参值里含另一个占位符形态的完整句（纸张/自定义名这类玩家可控串的现实形态）。
	TEST_ASSERT_EQUAL( \
		lang_interpolate("Zxqv {0} Qwrp {1} Zxqv", list("Blorp {1} Blorp", "Vunk")), \
		"Zxqv Blorp {1} Blorp Qwrp Vunk Zxqv", \
		"纸张类实参里的花括号被后续实参吞掉")

	// ③ 基础填充，以及与出现顺序无关的重排（中文语序靠这个）。
	TEST_ASSERT_EQUAL( \
		lang_interpolate("Zxqv {0} Qwrp {1}.", list("Blorp", "Vunk")), \
		"Zxqv Blorp Qwrp Vunk.", \
		"基础位置填充错误")
	TEST_ASSERT_EQUAL( \
		lang_interpolate("Zxqv {1} Qwrp {0}.", list("Blorp", "Vunk")), \
		"Zxqv Vunk Qwrp Blorp.", \
		"占位符重排失效")

	// ④ 同一占位符出现多次：每处都要填。
	TEST_ASSERT_EQUAL( \
		lang_interpolate("{0} Qwrp {0}.", list("Blorp")), \
		"Blorp Qwrp Blorp.", \
		"重复占位符未全部填充")

	// ⑤ 越界占位符原样保留（模板与实参数量不匹配时不得截断或崩溃）。
	TEST_ASSERT_EQUAL( \
		lang_interpolate("{0} Qwrp {3}", list("Blorp", "Vunk")), \
		"Blorp Qwrp {3}", \
		"越界占位符未原样保留")

	// ⑥ 非 `{N}` 花括号按字面处理（CSS/JSON 片段混进文本时不得被当占位符）。
	TEST_ASSERT_EQUAL( \
		lang_interpolate("{0} Qwrp {not a slot} Zxqv {", list("Blorp")), \
		"Blorp Qwrp {not a slot} Zxqv {", \
		"非占位符花括号被误处理")

	// ⑦ 无实参 / 无占位符：原样返回（LANG 绝大多数调用走这条）。
	TEST_ASSERT_EQUAL(lang_interpolate("Zxqv Qwrp", list()), "Zxqv Qwrp", "无实参时应原样返回")
	TEST_ASSERT_EQUAL(lang_interpolate("Zxqv Qwrp", list("Blorp")), "Zxqv Qwrp", "无占位符时应原样返回")
