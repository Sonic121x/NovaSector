/// 守护「类型显示名/描述表」这条落地路径：显示边界拿到的 name/desc 若仍等于类型初值，就按**类型**
/// 直接取目录 key 走正向目录，而不是拿字符串倒查反查表。
///
/// 分层断言（照 i18n_real_catalog 的教训：合成数据只能验引擎、验不了真表；真表只能验完整性，
/// 验不了行为——因为单测 fixture 刻意不进目录）：
///   ① **真表完整性**：strings/i18n/type_vars.json 能解析、非空，且条目的 key 在 en 目录里真实存在
///      （抓「表与目录不同源」——那会让整条路径静默永不命中）。
///   ② **单词名能落地**：这是相对反查链的净增益（反查侧的多词闸门永远够不到单词）。
///   ③ **实例数据不被改写**：走完显示边界后 name/desc 仍是 canonical English —— 整套方案的地基，
///      `if(X.name == "…")` / `GLOB.foo[X.name]` 靠它。
///   ④ 身份名（name 偏离 initial(name)）不吃类型表。
///   ⑤ desc 侧同构。
/datum/unit_test/i18n_type_labels
	/// 注入前的 i18n 全局态，Destroy() 里恢复（TEST_ASSERT 失败会直接 return，恢复不能写在 Run() 末尾）。
	var/saved_locale
	var/saved_locale_resolved

#define I18N_TYPE_LABEL_LOCALE "i18n-typelabel-unittest"
#define I18N_TYPE_LABEL_NAME_KEY "unittest.0000000000000001"
#define I18N_TYPE_LABEL_DESC_KEY "unittest.0000000000000002"
/// 单词名：反查侧的多词闸门（lang_reverse_phrase_tgui / lang_fallback_pattern_safe）永远够不到它。
#define I18N_TYPE_LABEL_NAME "Cryostylane"
#define I18N_TYPE_LABEL_DESC "Bluespace"

/obj/item/i18n_type_label_test
	name = I18N_TYPE_LABEL_NAME
	desc = I18N_TYPE_LABEL_DESC

/datum/unit_test/i18n_type_labels/Destroy()
	if(!isnull(saved_locale))
		GLOB.i18n_server_locale = saved_locale
		GLOB.i18n_runtime_state = saved_locale_resolved
		GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET] -= I18N_TYPE_LABEL_LOCALE
		var/list/en_cache = GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][DEFAULT_UI_LOCALE]
		en_cache -= I18N_TYPE_LABEL_NAME_KEY
		en_cache -= I18N_TYPE_LABEL_DESC_KEY
		GLOB.i18n_runtime_domains -= I18N_TYPE_LABEL_LOCALE
		GLOB.i18n_reverse -= I18N_TYPE_LABEL_LOCALE
		// 表按 locale 惰性建；清掉并复位标志，让之后的调用按真实 locale 重建。
		GLOB.i18n_type_name_keys.Cut()
		GLOB.i18n_type_desc_keys.Cut()
		GLOB.i18n_type_var_tables_loaded = FALSE
		saved_locale = null
	return ..()

/datum/unit_test/i18n_type_labels/Run()
	saved_locale = GLOB.i18n_server_locale
	saved_locale_resolved = GLOB.i18n_runtime_state
	var/list/en_cache = GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][DEFAULT_UI_LOCALE]
	en_cache[I18N_TYPE_LABEL_NAME_KEY] = I18N_TYPE_LABEL_NAME
	en_cache[I18N_TYPE_LABEL_DESC_KEY] = I18N_TYPE_LABEL_DESC
	// 单测环境 locale==en，表会被短路成空；切到合成 locale才建得起来。
	GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][I18N_TYPE_LABEL_LOCALE] = list(
		I18N_TYPE_LABEL_NAME_KEY = "低温冷凝剂",
		I18N_TYPE_LABEL_DESC_KEY = "蓝空",
	)
	GLOB.i18n_server_locale = I18N_TYPE_LABEL_LOCALE
	GLOB.i18n_runtime_state = I18N_RUNTIME_READY

	// ① 真表完整性：非空，且条目的 key 必须真在 en 目录里（表与目录同源）。
	var/list/name_table = lang_type_name_keys()
	TEST_ASSERT(length(name_table) > 0, "类型显示名表为空：strings/i18n/type_vars.json 缺失或未由 nova-i18n extract 产出")
	en_cache = GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][DEFAULT_UI_LOCALE]
	TEST_ASSERT(islist(en_cache), "en 目录未加载")
	var/checked = 0
	for(var/atom_type in name_table)
		var/table_key = name_table[atom_type]
		TEST_ASSERT(!isnull(en_cache[table_key]), "类型表的 key [table_key]（[atom_type]）在 en 目录里不存在：表与目录不同源，运行期必然永不命中")
		checked++
		if(checked >= 200)
			break
	TEST_ASSERT(checked > 0, "类型显示名表没有可校验的条目")

	// 单测 fixture 刻意不进目录（见 extract.rs 的 in_unit_tests），行为层用合成条目验。
	name_table[/obj/item/i18n_type_label_test] = I18N_TYPE_LABEL_NAME_KEY
	var/list/desc_table = lang_type_desc_keys()
	desc_table[/obj/item/i18n_type_label_test] = I18N_TYPE_LABEL_DESC_KEY

	var/obj/item/i18n_type_label_test/subject = allocate(/obj/item/i18n_type_label_test)

	// ② 单词名落地（反查链在这里必然 miss）。
	TEST_ASSERT_EQUAL(subject.lang_localize_name_for_display(subject.name), "低温冷凝剂", "单词类型名没有走类型表（这正是它相对反查链的净增益）")

	// ⑤ desc 同构。
	TEST_ASSERT_EQUAL(subject.lang_localize_desc_for_display(subject.desc), "蓝空", "类型描述没有走类型表")

	// ③ 实例数据不被改写 —— 整套方案的地基。
	TEST_ASSERT_EQUAL(subject.name, I18N_TYPE_LABEL_NAME, "显示边界回写了实例 name：比较与查表会当场坏掉")
	TEST_ASSERT_EQUAL(subject.desc, I18N_TYPE_LABEL_DESC, "显示边界回写了实例 desc")

	// ④ 身份名不吃类型表。
	subject.name = "Someone's Cryostylane"
	TEST_ASSERT_EQUAL(subject.lang_localize_name_for_display(subject.name), "Someone's Cryostylane", "身份名被类型表翻掉了")

#undef I18N_TYPE_LABEL_LOCALE
#undef I18N_TYPE_LABEL_NAME_KEY
#undef I18N_TYPE_LABEL_DESC_KEY
#undef I18N_TYPE_LABEL_NAME
#undef I18N_TYPE_LABEL_DESC
