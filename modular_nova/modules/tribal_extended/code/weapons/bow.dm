/obj/item/gun/ballistic/bow/tribalbow
	icon = 'modular_nova/modules/tribal_extended/icons/projectile.dmi'
	lefthand_file = 'modular_nova/modules/tribal_extended/icons/bows_lefthand.dmi'
	righthand_file = 'modular_nova/modules/tribal_extended/icons/bows_righthand.dmi'
	worn_icon = 'modular_nova/modules/tribal_extended/icons/back.dmi'
	inhand_icon_state = "bow"
	icon_state = null
	base_icon_state = "bow"
	worn_icon_state = "bow"
	slot_flags = ITEM_SLOT_BACK

/obj/item/gun/ballistic/bow/tribalbow/ashen
	name = "骨弓"
	desc = "某种由骨头和缠绕的筋腱制成的原始投射武器，出奇地坚固。"
	icon = 'modular_nova/modules/tribal_extended/icons/projectile.dmi'
	icon_state = "ashenbow"
	base_icon_state = "ashenbow"
	inhand_icon_state = "ashenbow"
	worn_icon_state = "ashenbow"
	force = 20
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT * 4)

/obj/item/gun/ballistic/bow/tribalbow/pipe
	name = "管弓"
	desc = "便携且光滑，但你用池面条打人可能效果更好。"
	icon = 'modular_nova/modules/tribal_extended/icons/projectile.dmi'
	icon_state = "pipebow"
	base_icon_state = "pipebow"
	inhand_icon_state = "pipebow"
	worn_icon_state = "pipebow"
	force = 10
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_SUITSTORE
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5, /datum/material/plastic = SHEET_MATERIAL_AMOUNT * 5)
