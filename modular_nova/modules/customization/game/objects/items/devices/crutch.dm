/obj/item/cane/crutch
	name = "拐杖"
	desc = "一种通常由腿部受伤恢复期人员使用的拐杖。"
	icon = 'modular_nova/master_files/icons/obj/staff.dmi'
	icon_state = "crutch"
	inhand_icon_state = "crutch"
	lefthand_file = 'modular_nova/master_files/icons/mob/inhands/melee_lefthand.dmi'
	righthand_file = 'modular_nova/master_files/icons/mob/inhands/melee_righthand.dmi'
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.5)

// stupid DM inheritance, we have to remove our icon overrides for subtypes
/obj/item/cane/crutch/wood
	icon = 'icons/obj/weapons/staff.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'

