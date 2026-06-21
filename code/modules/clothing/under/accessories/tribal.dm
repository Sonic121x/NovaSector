// Tribal undershirt accessories, made from bone or sinew.
/obj/item/clothing/accessory/talisman
	name = "骨制护身符"
	desc = "猎人的护身符，有人说古神会眷顾佩戴它的人。"
	icon_state = "talisman"
	attachment_slot = NONE
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT * 2)

/obj/item/clothing/accessory/skullcodpiece
	name = "颅骨护裆"
	desc = "一个颅骨形状的装饰品，旨在保护生命中重要的东西。"
	icon_state = "skull"
	attachment_slot = GROIN
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT * 2)

/obj/item/clothing/accessory/skilt
	name = "筋腱短裙"
	desc = "最后说一遍。这是苏格兰短裙，不是裙子。"
	icon_state = "skilt"
	minimize_when_attached = FALSE
	attachment_slot = GROIN
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT)
