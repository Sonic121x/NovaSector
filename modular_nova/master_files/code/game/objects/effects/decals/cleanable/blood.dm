/obj/effect/decal/cleanable/blood/gibs/NeverShouldHaveComeHere(turf/here_turf)
	return !islava(here_turf) && ..()

// NOVA EDIT ADDITION START - i18n
/**
 * 血迹类污渍的显示名是**每次 update_name() 现拼的**：
 *     "[dry_prefix] [base_name] [血液名] [base_suffix]" → "pool of oil"、"dried pool of blood"、"blood trail"
 * 整串永远不是目录键；类型表按 `initial(name)` 取键也对不上（`/blood/oil` 的 initial 是 "motor oil"）。
 * 默认血看着正常纯属巧合 —— 它拼出来的 "pool of blood" 恰好等于自己的 initial(name)。
 * 玩家实测报的「那是 pool of oil.」（描述已是中文）就是这个反差。
 *
 * 按构件拆开分别翻：血液名走正常的整串精确反查（`oil` → 油，单词也能命中），前后缀走域内表
 * （它们是 "pool of"/"dried"/"trail" 这种常见词，进全局反查表就是线缆颜色那类事故）。
 * 任一构件查不到就整条交回默认链，不产出半中半英的名字。
 */
/obj/effect/decal/cleanable/blood/lang_localize_name_for_display(display_name)
	var/localized = lang_localize_blood_decal_name(src, display_name)
	return localized || ..()
// NOVA EDIT ADDITION END
