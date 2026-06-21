// Completely made up materials to be sold in bar form by jarnsmiour in cargo, *should* be unobtainable otherwise

// Darkish blue kinda material

/datum/material/cobolterium
	name = "钴波尔特合金"
	desc = "钴波尔特合金"
	color = list(0.2,0.5,0.7,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0)
	greyscale_color = "#264d61"
	mat_flags = MATERIAL_CLASS_RIGID | MATERIAL_BASIC_RECIPES | MATERIAL_CLASS_METAL
	mat_properties = list(
		MATERIAL_DENSITY = 7,
		MATERIAL_HARDNESS = 7,
		MATERIAL_FLEXIBILITY = 2,
		MATERIAL_REFLECTIVITY = 4,
		MATERIAL_ELECTRICAL = 6,
		MATERIAL_THERMAL = 6,
		MATERIAL_CHEMICAL = 6,
	)
	sheet_type = /obj/item/stack/sheet/cobolterium

/datum/material/cobolterium/on_accidental_mat_consumption(mob/living/carbon/victim, obj/item/source_item)
	. = ..()
	if(!HAS_TRAIT(victim, TRAIT_ROCK_EATER))
		victim.apply_damage(10, BRUTE, BODY_ZONE_HEAD, wound_bonus = 5)
		return TRUE

/obj/item/stack/sheet/cobolterium
	name = "钴波尔特合金锭"
	desc = "钴蓝色的金属，可能真的就是钴。"
	singular_name = "cobolterium bar"
	icon = 'modular_nova/modules/company_imports/icons/special_metals_stack.dmi'
	icon_state = "precious-metals"
	material_flags = MATERIAL_EFFECTS | MATERIAL_COLOR
	mats_per_unit = list(/datum/material/cobolterium = SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/cobolterium
	material_type = /datum/material/cobolterium
	material_modifier = 1

/obj/item/stack/sheet/cobolterium/three
	amount = 3

// More copper colored material

/datum/material/copporcitite
	name = "copporcitite"
	desc = "Copporcitite"
	color = list(0.8,0.35,0.1,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0)
	greyscale_color = "#c55a1d"
	mat_flags = MATERIAL_CLASS_RIGID | MATERIAL_BASIC_RECIPES | MATERIAL_CLASS_METAL
	mat_properties = list(
		MATERIAL_DENSITY = 6,
		MATERIAL_HARDNESS = 5,
		MATERIAL_FLEXIBILITY = 2,
		MATERIAL_REFLECTIVITY = 3,
		MATERIAL_ELECTRICAL = 8,
		MATERIAL_THERMAL = 8,
		MATERIAL_CHEMICAL = 3,
	)
	sheet_type = /obj/item/stack/sheet/copporcitite

/datum/material/copporcitite/on_accidental_mat_consumption(mob/living/carbon/victim, obj/item/source_item)
	. = ..()
	if(!HAS_TRAIT(victim, TRAIT_ROCK_EATER))
		victim.apply_damage(10, BRUTE, BODY_ZONE_HEAD, wound_bonus = 5)
		return TRUE

/obj/item/stack/sheet/copporcitite
	name = "copporcitite 锭"
	desc = "铜色的金属，可能真的就是铜。"
	singular_name = "copporcitite bar"
	icon = 'modular_nova/modules/company_imports/icons/special_metals_stack.dmi'
	icon_state = "precious-metals"
	material_flags = MATERIAL_EFFECTS | MATERIAL_COLOR
	mats_per_unit = list(/datum/material/copporcitite = SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/copporcitite
	material_type = /datum/material/copporcitite
	material_modifier = 1

/obj/item/stack/sheet/copporcitite/three
	amount = 3

// Super blued-silver color

/datum/material/tinumium
	name = "tinumium"
	desc = "Tinumium"
	color = list(0.45,0.5,0.6,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0)
	greyscale_color = "#717e97"
	mat_flags = MATERIAL_CLASS_RIGID | MATERIAL_BASIC_RECIPES | MATERIAL_CLASS_METAL
	mat_properties = list(
		MATERIAL_DENSITY = 4,
		MATERIAL_HARDNESS = 5,
		MATERIAL_FLEXIBILITY = 3,
		MATERIAL_REFLECTIVITY = 3,
		MATERIAL_ELECTRICAL = 4,
		MATERIAL_THERMAL = 5,
		MATERIAL_CHEMICAL = 5,
	)
	sheet_type = /obj/item/stack/sheet/tinumium

/datum/material/tinumium/on_accidental_mat_consumption(mob/living/carbon/victim, obj/item/source_item)
	. = ..()
	if(!HAS_TRAIT(victim, TRAIT_ROCK_EATER))
		victim.apply_damage(10, BRUTE, BODY_ZONE_HEAD, wound_bonus = 5)
		return TRUE

/obj/item/stack/sheet/tinumium
	name = "tinumium 锭"
	desc = "严重发蓝的银色金属。"
	singular_name = "tinumium bar"
	icon = 'modular_nova/modules/company_imports/icons/special_metals_stack.dmi'
	icon_state = "precious-metals"
	material_flags = MATERIAL_EFFECTS | MATERIAL_COLOR
	mats_per_unit = list(/datum/material/tinumium = SHEET_MATERIAL_AMOUNT )
	merge_type = /obj/item/stack/sheet/tinumium
	material_type = /datum/material/tinumium
	material_modifier = 1

/obj/item/stack/sheet/tinumium/three
	amount = 3

// Brassy yellow color

/datum/material/brussite
	name = "brussite"
	desc = "Brussite"
	color = list(0.9,0.75,0.4,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0)
	greyscale_color = "#E1C16E"
	mat_flags = MATERIAL_CLASS_RIGID | MATERIAL_BASIC_RECIPES | MATERIAL_CLASS_METAL
	mat_properties = list(
		MATERIAL_DENSITY = 6,
		MATERIAL_HARDNESS = 6,
		MATERIAL_FLEXIBILITY = 3,
		MATERIAL_REFLECTIVITY = 4,
		MATERIAL_ELECTRICAL = 8,
		MATERIAL_THERMAL = 8,
		MATERIAL_CHEMICAL = 3,
	)
	sheet_type = /obj/item/stack/sheet/brussite

/datum/material/brussite/on_accidental_mat_consumption(mob/living/carbon/victim, obj/item/source_item)
	. = ..()
	if(!HAS_TRAIT(victim, TRAIT_ROCK_EATER))
		victim.apply_damage(10, BRUTE, BODY_ZONE_HEAD, wound_bonus = 5)
		return TRUE

/obj/item/stack/sheet/brussite
	name = "brussite 锭"
	desc = "黄铜色的金属，可能真的就是黄铜。"
	singular_name = "brussite bar"
	icon = 'modular_nova/modules/company_imports/icons/special_metals_stack.dmi'
	icon_state = "precious-metals"
	material_flags = MATERIAL_EFFECTS | MATERIAL_COLOR
	mats_per_unit = list(/datum/material/brussite = SHEET_MATERIAL_AMOUNT )
	merge_type = /obj/item/stack/sheet/brussite
	material_type = /datum/material/brussite
	material_modifier = 1

/obj/item/stack/sheet/brussite/three
	amount = 3
