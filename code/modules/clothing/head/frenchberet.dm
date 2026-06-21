/obj/item/clothing/head/beret/frenchberet
	name = "法国贝雷帽"
	desc = "一顶优质贝雷帽，散发着爱抽连环烟、爱喝葡萄酒的巴黎人气息。不知为何，你会觉得不太想参与军事冲突。"
	flags_1 = NO_NEW_GAGS_PREVIEW_1
	clothing_traits = list(TRAIT_GARLIC_BREATH)

/obj/item/clothing/head/beret/frenchberet/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/speechmod, replacements = strings("french_replacement.json", "french"), end_string = list(" Honh honh honh!"," Honh!"," Zut Alors!"), end_string_chance = 3, slots = ITEM_SLOT_HEAD)
