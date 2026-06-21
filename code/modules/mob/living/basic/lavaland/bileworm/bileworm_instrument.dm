/obj/item/instrument/bilehorn
	name = "骨喇叭"
	desc = "虫子的某些器官被重新组合，从而产生了美妙的音乐，而不是胆汁。不过还是保留了“胆汁虫”这个名称，因为作为一种乐器，它确实相当恶心。"
	force = 5
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	icon_state = "bilehorn"
	allowed_instrument_ids = "bilehorn"
	inhand_icon_state = null
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT * 2)

/datum/crafting_recipe/bilehorn
	name = "骨喇叭"
	reqs = list(
		/obj/item/stack/sheet/animalhide/bileworm = 4,
		/obj/item/stack/sheet/bone = 2,
		/obj/item/crusher_trophy/bileworm_spewlet = 1,
	)
	result = /obj/item/instrument/bilehorn
	category = CAT_ENTERTAINMENT
