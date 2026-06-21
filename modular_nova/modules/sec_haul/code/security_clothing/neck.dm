/obj/item/clothing/neck/cloak/hos/blue
	icon = 'modular_nova/master_files/icons/obj/clothing/neck.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/neck.dmi'
	icon_state = "hoscloak_blue"

/datum/atom_skin/security_cape
	abstract_type = /datum/atom_skin/security_cape

/datum/atom_skin/security_cape/black
	preview_name = "Black Variant"
	new_icon_state = "cape_black"

/datum/atom_skin/security_cape/red
	preview_name = "Red Variant"
	new_icon_state = "cape_red"

/datum/atom_skin/security_cape/blue
	preview_name = "Blue Variant"
	new_icon_state = "cape_blue"

/datum/atom_skin/security_cape/white
	preview_name = "White Variant"
	new_icon_state = "cape_white"

/obj/item/clothing/neck/security_cape
	name = "安保披风"
	desc = "安保干员穿戴的时尚披风。"
	icon = 'modular_nova/master_files/icons/obj/clothing/neck.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/neck.dmi'
	icon_state = "cape_black"
	inhand_icon_state = "" //no unique inhands
	///Decides the shoulder it lays on, false = RIGHT, TRUE = LEFT
	var/swapped = FALSE

/obj/item/clothing/neck/security_cape/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/security_cape)

/obj/item/clothing/neck/security_cape/click_alt(mob/user)
	swapped = !swapped
	to_chat(user, span_notice("你交换了[src]将要搭在哪只手臂上。"))
	update_appearance()
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/neck/security_cape/update_appearance(updates)
	. = ..()
	if(swapped)
		worn_icon_state = icon_state
	else
		worn_icon_state = "[icon_state]_left"

	usr.update_worn_neck()

/datum/atom_skin/security_gauntlet
	abstract_type = /datum/atom_skin/security_gauntlet

/datum/atom_skin/security_gauntlet/black
	preview_name = "Black Variant"
	new_icon_state = "armplate_black"

/datum/atom_skin/security_gauntlet/red
	preview_name = "Red Variant"
	new_icon_state = "armplate_red"

/datum/atom_skin/security_gauntlet/blue
	preview_name = "Blue Variant"
	new_icon_state = "armplate_blue"

/datum/atom_skin/security_gauntlet/capeless
	preview_name = "Capeless Variant"
	new_icon_state = "armplate"

/obj/item/clothing/neck/security_cape/armplate
	name = "安保臂铠"
	desc = "安保干员穿戴的时尚全臂护手。护手本身由塑料制成，不提供任何防护，但看起来酷毙了。"
	icon_state = "armplate_black"

/obj/item/clothing/neck/security_cape/armplate/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/security_gauntlet)
