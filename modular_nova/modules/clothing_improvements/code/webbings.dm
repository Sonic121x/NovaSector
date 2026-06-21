/obj/item/clothing/accessory/webbing
	name = "携行具"
	desc = "一套由合成材料腰带和扣具组成的坚固装备，随时准备分担你的负重。"
	icon = 'modular_nova/master_files/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/accessories.dmi'
	icon_state = "webbing"
	minimize_when_attached = FALSE
	attachment_slot = NONE

/datum/storage/pockets/webbing
	do_rustle = TRUE
	max_slots = 3
	max_specific_storage = WEIGHT_CLASS_SMALL

/obj/item/clothing/accessory/webbing/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/pockets/webbing)

/obj/item/clothing/accessory/webbing/can_attach_accessory(obj/item/clothing/under/attach_to, mob/living/user)
	. = ..()
	if(!.)
		return

	if(!isnull(attach_to.atom_storage))
		if(user)
			attach_to.balloon_alert(user, "不兼容！")
		return FALSE
	return TRUE

/datum/atom_skin/webbing_vest
	abstract_type = /datum/atom_skin/webbing_vest

/datum/atom_skin/webbing_vest/brown
	preview_name = "Brown"
	new_icon_state = "vest_brown"

/datum/atom_skin/webbing_vest/black
	preview_name = "Black"
	new_icon_state = "vest_black"

/datum/atom_skin/webbing_vest/white
	preview_name = "Medical White"
	new_icon_state = "vest_white"

/obj/item/clothing/accessory/webbing/vest
	name = "携行背心"
	desc = "一件坚固的背心，上面有很多口袋，可以装下你需要的任何东西，随时准备分担你的负重。"
	icon_state = "vest_brown"

/obj/item/clothing/accessory/webbing/vest/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/webbing_vest)

/datum/atom_skin/drop_pouches
	abstract_type = /datum/atom_skin/drop_pouches

/datum/atom_skin/drop_pouches/brown
	preview_name = "Brown"
	new_icon_state = "thigh_brown"

/datum/atom_skin/drop_pouches/black
	preview_name = "Black"
	new_icon_state = "thigh_black"

/datum/atom_skin/drop_pouches/white
	preview_name = "White"
	new_icon_state = "thigh_white"

/obj/item/clothing/accessory/webbing/pouch
	name = "垂降袋"
	desc = "一对容量不错的坚固垂降袋，随时准备分担你的负重。"
	icon_state = "thigh_brown"

/obj/item/clothing/accessory/webbing/pouch/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/drop_pouches)

/obj/item/clothing/accessory/webbing/pouch/black
	icon_state = "thigh_black"

/datum/atom_skin/storage_rigging
	abstract_type = /datum/atom_skin/storage_rigging

/datum/atom_skin/storage_rigging/full
	preview_name = "Full Rigging"
	new_icon_state = "pilot_webbing1"

/datum/atom_skin/storage_rigging/low_slung
	preview_name = "Low Slung"
	new_icon_state = "pilot_webbing2"

/obj/item/clothing/accessory/webbing/pilot
	name = "储物索具"
	icon_state = "pilot_webbing1"

/obj/item/clothing/accessory/webbing/pilot/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/storage_rigging)
