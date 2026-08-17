/// 守护 atom/turf 名称本地化的显示边界：运行时实例保留 canonical English，只在 examine/hover
/// 输出时翻译（`name`/`desc` 都是 BYOND appearance 字段，Initialize 期改写会翻搅全图外观）。
///
/// 合成目录后创建 obj、turf 与 human，断言：
///   ① Initialize 后实例的 name/desc（含从 appearance 读回的那份）仍是英文；
///   ② 静态类型名和描述在 examine 显示译文；
///   ③ item rename trait 与运行期身份名均不会被目录碰撞误翻；
///   ④ human 的 examine 和 hover 共用身份名保护边界。
///
/// 注：① 只能证明「实例上读不到译文」，证不到「没有多生成 appearance」——DM 观测不到外观表。
/// 它守的是回归方向（有人把原地反查加回 Initialize 就会红），不是外观数量本身。
/datum/unit_test/i18n_display_boundary
	normal_floor_required = TRUE
	/// 注入前的 i18n 全局态，Destroy() 里恢复（TEST_ASSERT 失败会直接 return，恢复不能写在 Run() 末尾）。
	var/saved_locale
	var/saved_locale_resolved
	var/list/injected_en_keys

#define I18N_DISPLAY_TEST_LOCALE "i18n-display-unittest"
#define I18N_DISPLAY_TEST_NAME "Welding Fuel"
#define I18N_DISPLAY_TEST_DESC "Carbon Dioxide"

/obj/item/i18n_display_boundary_test
	name = I18N_DISPLAY_TEST_NAME
	desc = I18N_DISPLAY_TEST_DESC

/turf/open/floor/i18n_display_boundary_test
	name = I18N_DISPLAY_TEST_NAME
	desc = I18N_DISPLAY_TEST_DESC

/mob/living/basic/mouse/i18n_display_boundary_test
	name = I18N_DISPLAY_TEST_NAME
	desc = I18N_DISPLAY_TEST_DESC

/// 恢复注入的 i18n 全局态。放在 Destroy()（框架保证调用）而不是 Run() 末尾：TEST_ASSERT 失败即
/// return，若恢复写在末尾，合成 locale 会留在 GLOB 里，把之后每一个 i18n 测试连带染红。
/datum/unit_test/i18n_display_boundary/Destroy()
	if(!isnull(saved_locale))
		GLOB.i18n_server_locale = saved_locale
		GLOB.i18n_locale_resolved = saved_locale_resolved
		var/list/en_cache = GLOB.i18n_cache[DEFAULT_UI_LOCALE]
		if(islist(en_cache))
			for(var/key in injected_en_keys)
				en_cache -= key
		GLOB.i18n_cache -= I18N_DISPLAY_TEST_LOCALE
		GLOB.i18n_reverse -= I18N_DISPLAY_TEST_LOCALE
		GLOB.i18n_unreverse -= I18N_DISPLAY_TEST_LOCALE
		saved_locale = null
	return ..()

/datum/unit_test/i18n_display_boundary/Run()
	var/list/en_cache = GLOB.i18n_cache[DEFAULT_UI_LOCALE]
	if(!islist(en_cache))
		en_cache = list()
		GLOB.i18n_cache[DEFAULT_UI_LOCALE] = en_cache

	var/list/test_pairs = list(
		"unittest.display_name" = list(I18N_DISPLAY_TEST_NAME, "焊接燃料"),
		"unittest.display_desc" = list(I18N_DISPLAY_TEST_DESC, "二氧化碳"),
	)
	var/list/test_cache = list()
	for(var/key in test_pairs)
		var/list/pair = test_pairs[key]
		en_cache[key] = pair[1]
		test_cache[key] = pair[2]
	// 记录恢复所需的状态**再**改全局：Destroy() 靠 saved_locale 非空判断该不该恢复。
	saved_locale = GLOB.i18n_server_locale
	saved_locale_resolved = GLOB.i18n_locale_resolved
	injected_en_keys = test_pairs.Copy()
	GLOB.i18n_cache[I18N_DISPLAY_TEST_LOCALE] = test_cache
	GLOB.i18n_server_locale = I18N_DISPLAY_TEST_LOCALE
	GLOB.i18n_locale_resolved = TRUE
	GLOB.i18n_reverse -= I18N_DISPLAY_TEST_LOCALE
	GLOB.i18n_unreverse -= I18N_DISPLAY_TEST_LOCALE

	var/obj/item/i18n_display_boundary_test/test_item = allocate(/obj/item/i18n_display_boundary_test)
	TEST_ASSERT_EQUAL(test_item.name, I18N_DISPLAY_TEST_NAME, "obj Initialize 不应原地翻译 name")
	TEST_ASSERT_EQUAL(test_item.desc, I18N_DISPLAY_TEST_DESC, "obj Initialize 不应原地翻译 desc")
	// 从 appearance 读回而不是只读实例 var：`.appearance` 给的是不可变 /appearance，用 mutable_appearance
	// 标注类型是假的，所以显式拷一份可变副本再读。
	var/mutable_appearance/item_appearance = new(test_item.appearance)
	TEST_ASSERT_EQUAL(item_appearance.name, I18N_DISPLAY_TEST_NAME, "obj appearance 不应含 locale 专属 name")
	TEST_ASSERT_EQUAL(item_appearance.desc, I18N_DISPLAY_TEST_DESC, "obj appearance 不应含 locale 专属 desc")
	TEST_ASSERT(findtext(test_item.get_examine_name(null), "焊接燃料"), "obj examine 名称应在显示边界翻译")
	TEST_ASSERT(findtext(jointext(test_item.examine(null), "\n"), "二氧化碳"), "obj examine 描述应在显示边界翻译")

	var/turf/open/floor/i18n_display_boundary_test/test_turf = run_loc_floor_bottom_left.ChangeTurf(/turf/open/floor/i18n_display_boundary_test)
	TEST_ASSERT_EQUAL(test_turf.name, I18N_DISPLAY_TEST_NAME, "turf Initialize 不应原地翻译 name")
	TEST_ASSERT_EQUAL(test_turf.desc, I18N_DISPLAY_TEST_DESC, "turf Initialize 不应原地翻译 desc")
	var/mutable_appearance/turf_appearance = new(test_turf.appearance)
	TEST_ASSERT_EQUAL(turf_appearance.name, I18N_DISPLAY_TEST_NAME, "turf appearance 不应含 locale 专属 name")
	TEST_ASSERT_EQUAL(turf_appearance.desc, I18N_DISPLAY_TEST_DESC, "turf appearance 不应含 locale 专属 desc")
	TEST_ASSERT(findtext(test_turf.get_examine_name(null), "焊接燃料"), "turf examine 名称应在显示边界翻译")

	var/mob/living/carbon/human/consistent/test_human = allocate(/mob/living/carbon/human/consistent)
	test_human.fully_replace_character_name(test_human.real_name, I18N_DISPLAY_TEST_NAME)
	TEST_ASSERT_EQUAL(test_human.name, I18N_DISPLAY_TEST_NAME, "human 身份名赋值后应保持玩家输入")
	TEST_ASSERT_EQUAL(test_human.lang_localize_name_for_display(test_human.name), I18N_DISPLAY_TEST_NAME, "human hover 不得翻译碰撞目录的身份名")
	var/human_examine_name = test_human.get_examine_name(test_human)
	TEST_ASSERT(findtext(human_examine_name, I18N_DISPLAY_TEST_NAME), "human examine 应保留碰撞目录的身份名")
	TEST_ASSERT(!findtext(human_examine_name, "焊接燃料"), "human examine 不得翻译碰撞目录的身份名")

	// 反向：仍等于 initial(name) 的 mob 就是类型标签（未命名的简单生物、宠物摘掉项圈还原后），
	// 该翻。这条守住 /mob 覆盖判据只按 initial(name) 走、没把整个 mob 家族一刀切成不翻。
	var/mob/living/basic/mouse/i18n_display_boundary_test/test_mouse = allocate(/mob/living/basic/mouse/i18n_display_boundary_test)
	TEST_ASSERT_EQUAL(test_mouse.name, I18N_DISPLAY_TEST_NAME, "mob Initialize 不应原地翻译 name")
	// user 必须非空：/mob/living/get_examine_name 会 SEND_SIGNAL(user, …)。
	TEST_ASSERT(findtext(test_mouse.get_examine_name(test_human), "焊接燃料"), "静态 mob 类型名应在显示边界翻译")
	// `set_name()` 形态：「类型名 (编号)」的前缀该翻、后缀原样保留（异种/蜂/无人机等都走这条）。
	TEST_ASSERT_EQUAL(
		test_mouse.lang_localize_name_for_display("[I18N_DISPLAY_TEST_NAME] (123)"),
		"焊接燃料 (123)",
		"类型名 + 括号后缀应翻前缀、留后缀",
	)
	// 但换成别的形状就必须当身份名保护住（前缀不等于 initial(name) / 没有括号后缀）。
	TEST_ASSERT_EQUAL(
		test_mouse.lang_localize_name_for_display("[I18N_DISPLAY_TEST_NAME] Junior"),
		"[I18N_DISPLAY_TEST_NAME] Junior",
		"非括号后缀的运行期名不得翻译",
	)

	// tgui_input_list 的显示串↔原值往返：选项文本翻成译文，items_map 用同一个显示串作键，
	// 回传后仍取回**原始值**。这条一旦回归就是「中文选项点了没反应」的静默失效。
	var/datum/tgui_list_input/list_input = new(null, "msg", "title", list(I18N_DISPLAY_TEST_NAME), I18N_DISPLAY_TEST_NAME, 0, GLOB.always_state)
	TEST_ASSERT_EQUAL(list_input.items[1], "焊接燃料", "tgui_input_list 选项文本应本地化")
	TEST_ASSERT_EQUAL(list_input.items_map["焊接燃料"], I18N_DISPLAY_TEST_NAME, "译名键应能取回原值")
	TEST_ASSERT_EQUAL(list_input.default, "焊接燃料", "default 应换成显示形态，否则前端预选落空")
	qdel(list_input)

	ADD_TRAIT(test_item, TRAIT_WAS_RENAMED, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(findtext(test_item.get_examine_name(null), I18N_DISPLAY_TEST_NAME), "玩家改名应保留原文，不得被目录碰撞误翻")
	// 全局态恢复在 Destroy()，不放这里——见上面的注释。

#undef I18N_DISPLAY_TEST_LOCALE
#undef I18N_DISPLAY_TEST_NAME
#undef I18N_DISPLAY_TEST_DESC
