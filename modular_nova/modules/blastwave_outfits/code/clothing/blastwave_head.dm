/datum/atom_skin/blastwave_helmet
	abstract_type = /datum/atom_skin/blastwave_helmet

/datum/atom_skin/blastwave_helmet/purple
	preview_name = "Default (Purple)"
	new_icon_state = "blastwave_helmet"

/datum/atom_skin/blastwave_helmet/red
	preview_name = "Red"
	new_icon_state = "blastwave_helmet_r"

/datum/atom_skin/blastwave_helmet/green
	preview_name = "Green"
	new_icon_state = "blastwave_helmet_g"

/datum/atom_skin/blastwave_helmet/blue
	preview_name = "Blue"
	new_icon_state = "blastwave_helmet_b"

/datum/atom_skin/blastwave_helmet/yellow
	preview_name = "Yellow"
	new_icon_state = "blastwave_helmet_y"

/obj/item/clothing/head/blastwave
	name = "冲击波头盔"
	desc = "一个涂了漆的塑料头盔。其防护力与一个名为'防空洞'的纸板箱相当。"
	icon = 'modular_nova/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head.dmi'
	icon_state = "blastwave_helmet"
	flags_inv = HIDEHAIR

/obj/item/clothing/head/blastwave/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/blastwave_helmet)

/datum/atom_skin/blastwave_officer_cap
	abstract_type = /datum/atom_skin/blastwave_officer_cap

/datum/atom_skin/blastwave_officer_cap/purple
	preview_name = "Default (Purple)"
	new_icon_state = "blastwave_offcap"

/datum/atom_skin/blastwave_officer_cap/red
	preview_name = "Red"
	new_icon_state = "blastwave_offcap_r"

/datum/atom_skin/blastwave_officer_cap/green
	preview_name = "Green"
	new_icon_state = "blastwave_offcap_g"

/datum/atom_skin/blastwave_officer_cap/blue
	preview_name = "Blue"
	new_icon_state = "blastwave_offcap_b"

/datum/atom_skin/blastwave_officer_cap/yellow
	preview_name = "Yellow"
	new_icon_state = "blastwave_offcap_y"

/obj/item/clothing/head/blastwave/officer
	name = "冲击波大檐帽"
	desc = "一顶简单的军帽。"
	icon_state = "blastwave_offcap"
	flags_inv = NONE

/obj/item/clothing/head/blastwave/officer/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/blastwave_officer_cap)
