/datum/atom_skin/tarkon_gauntlet
	abstract_type = /datum/atom_skin/tarkon_gauntlet

/datum/atom_skin/tarkon_gauntlet/caped
	preview_name = "Caped Variant"
	new_icon_state = "armplate_shemaugh"

/datum/atom_skin/tarkon_gauntlet/capeless
	preview_name = "Capeless Variant"
	new_icon_state = "armplate"

/obj/item/clothing/neck/security_cape/tarkon
	name = "塔康防护臂铠"
	desc = "塔康工业用于保护员工主要工具臂的全臂铠。然而，在真正的战斗中用处不大。"
	worn_icon = 'modular_nova/modules/tarkon/icons/mob/clothing/neck.dmi'
	icon = 'modular_nova/modules/tarkon/icons/obj/clothing/neck.dmi'
	icon_state = "armplate_shemaugh"

/obj/item/clothing/neck/security_cape/tarkon/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/tarkon_gauntlet)
