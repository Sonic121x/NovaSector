// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/slime_scanner
	name = "slime scanner"
	desc = "A device that analyzes a slime's internal composition and measures its stats."
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "slime_scanner"
	inhand_icon_state = "analyzer"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	obj_flags = CONDUCTS_ELECTRICITY
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 3, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 2)

/obj/item/slime_scanner/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE
	if(!user.can_read(src)) //NOVA EDIT CHANGE - Blind People Can Analyze Again - ORIGINAL : if(!user.can_read(src) || user.is_blind())
		return ITEM_INTERACT_BLOCKING
	if (!isslime(interacting_with))
		to_chat(user, span_warning(LANG("obj.619bec23", null)))
		return ITEM_INTERACT_BLOCKING
	var/mob/living/basic/slime/scanned_slime = interacting_with
	playsound(src, SFX_INDUSTRIAL_SCAN, 20, TRUE, -2, TRUE, FALSE)
	slime_scan(scanned_slime, user)
	return ITEM_INTERACT_SUCCESS

/proc/slime_scan(mob/living/basic/slime/scanned_slime, mob/living/user)
	// NOVA EDIT CHANGE START - I18N: 整块报告逐行 LANG 化。原来是具名累加器 `to_render +=` 拼插值，
	// 既非裸 `.` 也不在 examine proc 里 → 抽取器的整句闸把它整块挡在目录外；而它是玩家盯得最久的
	// 面板之一。突变颜色走 lang_slime_colour（顶层表，不进全局反查表——颜色同时是 icon_state/突变表键）。
	// ORIGINAL: 见 git 历史，形态为 "<b>Slime scan results:</b>\n…" 一路 += 拼接。
	var/to_render = "<b>[LANG("_root.459c8a52", null)]</b>\
					\n[span_notice(lang_reverse_text("[scanned_slime.slime_type.colour] [scanned_slime.life_stage] slime"))]\
					\n[LANG("_root.2a47f665", list(scanned_slime.nutrition, SLIME_MAX_NUTRITION))]"

	if (scanned_slime.nutrition < SLIME_STARVE_NUTRITION)
		to_render += "\n[span_warning(LANG("_root.3c9cb2fc", null))]"
	else if (scanned_slime.nutrition < SLIME_HUNGER_NUTRITION)
		to_render += "\n[span_warning(LANG("_root.37838263", null))]"

	to_render += "\n[LANG("_root.0b94a02a", list(scanned_slime.powerlevel))]\n[LANG("_root.878005df", list(round(scanned_slime.health/scanned_slime.maxHealth,0.01)*100))]"

	to_render += "\n[scanned_slime.slime_type.mutations.len > 1 ? LANG("_root.d8f34fa4", null) : LANG("_root.bdb4023f", null)] "
	var/list/mutation_text = list()
	for(var/datum/slime_type/key as anything in scanned_slime.slime_type.mutations)
		mutation_text += lang_slime_colour(initial(key.colour))

	if(!mutation_text.len)
		to_render += " [LANG("_root.0b6c8933", null)]"

	to_render += "[mutation_text.Join(", ")]"
	to_render += "\n[LANG("_root.5d0d3d5c", list(scanned_slime.mutation_chance))]"

	if (scanned_slime.cores > 1)
		to_render += "\n[LANG("_root.fb43dfa1", null)]"
	to_render += "\n[LANG("_root.999a945b", list(scanned_slime.amount_grown, SLIME_EVOLUTION_THRESHOLD))]"

	if(scanned_slime.crossbreed_modification)
		to_render += "\n[span_notice(LANG("_root.8056f8a5", list(scanned_slime.crossbreed_modification)))]\
					  \n[span_notice(LANG("_root.d9219f70", list(scanned_slime.applied_crossbreed_amount, SLIME_EXTRACT_CROSSING_REQUIRED)))]"
	// NOVA EDIT CHANGE END

	to_chat(user, boxed_message(jointext(to_render,"")))
