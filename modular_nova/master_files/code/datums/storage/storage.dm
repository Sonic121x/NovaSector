// NOVA EDIT ADDITION - I18N - 「可以容纳:」列表里的物品名本地化。
//
// 上游 set_holdable() 把每一项拼成 `"\a [initial(valid_item.name)]"`。`initial()` 取的是**英文
// 原名**（绕开了 Initialize 期的反查），而整条 `can_hold_description` 是运行期拼的、不是目录键。
// 于是落地只能靠字面 AC 的子串替换 —— 它按安全线**只收多词**，结果就是玩家看到的
// 「a limb / a 电路板 / a beaker / a 线圈」这种半译：多词名（circuit board→电路板）命中，
// 单词名（limb/beaker/bottle/assembly）整类漏掉。
//
// 这里在 `. = ..()` 之后按同样规则重建该描述，逐项走**精确反查**（单词也能命中，且是精确匹配、
// 不存在 AC 那种词内开火的风险）。命中的项丢掉 `\a` 冠词 —— 中文无冠词，留着就是「a 电路板」。
//
// 用覆盖而非改核心：上游若改了拼法，这里最多是重建结果与父类一致，不会静默失配。
/datum/storage/set_holdable(list/can_hold_list, list/cant_hold_list, list/exception_hold_list)
	. = ..()
	if(GLOB.i18n_server_locale == DEFAULT_UI_LOCALE || isnull(can_hold_list))
		return
	// 父 proc 对非 list 实参做过同样的归一（那是它的局部变量，这里要自己再做一次）。
	if(!islist(can_hold_list))
		can_hold_list = list(can_hold_list)
	if(!length(can_hold_list))
		return
	var/list/desc = list()
	for(var/obj/item/valid_item as anything in can_hold_list)
		var/item_name = initial(valid_item.name)
		var/localized = lang_reverse_text(item_name)
		desc += (localized != item_name) ? localized : "\a [item_name]"
	can_hold_description = "\n\t[span_notice("[desc.Join("\n\t")]")]"
