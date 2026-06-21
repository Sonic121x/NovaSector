/obj/structure/bed/double/pelt/synthetic
	name = "白色毛皮床"
	desc = "一张奢华的双人床，由合成白色狼皮制成。"
	icon_state = "pelt_bed_white"
	icon = 'modular_nova/modules/tribal_extended/icons/tribal_beds.dmi'
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 90
	resistance_flags = FLAMMABLE
	max_integrity = 100
	integrity_failure = 0.35
	max_buckled_mobs = 2
	build_stack_type = /obj/item/stack/sheet/leather
	build_stack_amount = 3
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 3)

/datum/crafting_recipe/synth_white_pelt_bed
	name = "合成白色毛皮床"
	category = CAT_FURNITURE
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND

	reqs = list(
		/obj/item/stack/sheet/leather = 3,
		/obj/item/stack/sheet/mineral/wood = 3,
	)

	result = /obj/structure/bed/double/pelt/synthetic

/obj/structure/bed/double/pelt/synthetic/black
	name = "黑色毛皮床"
	desc = "一张奢华的双人床，由合成黑色狼皮制成。"
	icon_state = "pelt_bed_black"
	icon = 'modular_nova/modules/tribal_extended/icons/tribal_beds.dmi'
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 3)

/datum/crafting_recipe/synth_black_pelt_bed
	name = "合成黑色毛皮床"
	category = CAT_FURNITURE
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND

	reqs = list(
		/obj/item/stack/sheet/leather = 3,
		/obj/item/stack/sheet/mineral/wood = 3,
	)

	result = /obj/structure/bed/double/pelt/synthetic/black

// Medieval oversized beds
/obj/structure/bed/oversized
	name = "单人超大床"
	desc = "一张奢华的床，邀请您，哦，旅者，在其上休憩。"
	icon = 'modular_nova/master_files/icons/obj/medieval/structures_64x64.dmi'
	icon_state = "bed_1x2"
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 90
	resistance_flags = FLAMMABLE
	max_integrity = 150
	integrity_failure = 0.35
	max_buckled_mobs = 2
	build_stack_type = /obj/item/stack/sheet/cloth
	build_stack_amount = 3
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 3)

/obj/structure/bed/oversized/atom_deconstruct(disassembled = TRUE)
	. = ..()
	new /obj/item/stack/sheet/mineral/wood(loc, build_stack_amount)

/datum/crafting_recipe/oversized_bed
	name = "单人超大床"
	category = CAT_FURNITURE
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND

	reqs = list(
		/obj/item/stack/sheet/cloth = 3,
		/obj/item/stack/sheet/mineral/wood = 3,
	)

	result = /obj/structure/bed/oversized

/obj/structure/bed/oversized/double
	name = "双人超大床"
	icon = 'modular_nova/master_files/icons/obj/medieval/structures_64x64.dmi'
	icon_state = "bed_2x2"
	max_buckled_mobs = 2
	build_stack_amount = 6
	max_integrity = 200
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 6)

/datum/crafting_recipe/oversized_bed_double
	name = "双人超大床"
	category = CAT_FURNITURE
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND

	reqs = list(
		/obj/item/stack/sheet/cloth = 6,
		/obj/item/stack/sheet/mineral/wood = 6,
	)

	result = /obj/structure/bed/oversized/double

/obj/structure/bed/oversized/triple
	name = "三倍超大床"
	icon = 'modular_nova/master_files/icons/obj/medieval/structures_96x96.dmi'
	icon_state = "bed_3x3"
	max_buckled_mobs = 4
	build_stack_amount = 10
	max_integrity = 250
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 10)

/datum/crafting_recipe/oversized_bed_triple
	name = "三倍超大床"
	category = CAT_FURNITURE
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND

	reqs = list(
		/obj/item/stack/sheet/cloth = 10,
		/obj/item/stack/sheet/mineral/wood = 10,
	)

	result = /obj/structure/bed/oversized/triple
