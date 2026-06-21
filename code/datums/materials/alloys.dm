/// Materials made from other materials.
/datum/material/alloy
	name = "合金"
	desc = "一种由两种或更多其他材料组成的材料。"
	abstract_type = /datum/material/alloy
	/// The materials this alloy is made from weighted by their ratios.
	var/list/composition = null

/datum/material/alloy/return_composition(amount = 1, flags)
	if(flags & MATCONTAINER_ACCEPT_ALLOYS)
		return ..()

	. = list()

	var/list/cached_comp = composition
	for(var/comp_mat in cached_comp)
		var/datum/material/component_material = SSmaterials.get_material(comp_mat)
		var/list/component_composition = component_material.return_composition(cached_comp[comp_mat], flags)
		for(var/comp_comp_mat in component_composition)
			.[comp_comp_mat] += component_composition[comp_comp_mat] * amount

/**
 * Plasteel
 * An alloy of iron and plasma.
 * Applies a significant slowdown effect to any and all items that contain it.
 */
/datum/material/alloy/plasteel
	name = "塑钢"
	desc = "将铁与等离子体融合后产生的重型材料。"
	color = "#706374"
	mat_flags = MATERIAL_BASIC_RECIPES | MATERIAL_CLASS_METAL | MATERIAL_CLASS_RIGID
	mat_properties = list(
		MATERIAL_DENSITY = 6,
		MATERIAL_HARDNESS = 8,
		MATERIAL_FLEXIBILITY = 1,
		MATERIAL_REFLECTIVITY = 5,
		MATERIAL_ELECTRICAL = 8,
		MATERIAL_THERMAL = 4,
		MATERIAL_CHEMICAL = 6,
	)
	value_per_unit = 0.135
	sheet_type = /obj/item/stack/sheet/plasteel
	material_reagent = list(/datum/reagent/iron = 1, /datum/reagent/toxin/plasma = 1)
	composition = list(/datum/material/iron = 1, /datum/material/plasma = 1)
	mat_rust_resistance = RUST_RESISTANCE_REINFORCED

/datum/material/alloy/plasteel/on_applied(atom/source, mat_amount, multiplier, from_slot)
	. = ..()
	if(istype(source, /obj/item/fishing_rod))
		ADD_TRAIT(source, TRAIT_ROD_LAVA_USABLE, REF(src))

/datum/material/alloy/plasteel/on_removed(atom/source, mat_amount, multiplier, from_slot)
	. = ..()
	if(istype(source, /obj/item/fishing_rod))
		REMOVE_TRAIT(source, TRAIT_ROD_LAVA_USABLE, REF(src))

/**
 * Plastitanium
 * An alloy of titanium and plasma.
 */
/datum/material/alloy/plastitanium
	name = "塑钛"
	desc = "将钛与等离子体融合后产生的极端耐热材料。"
	color = "#3a313a"
	mat_flags = MATERIAL_BASIC_RECIPES | MATERIAL_CLASS_METAL | MATERIAL_CLASS_RIGID
	mat_properties = list(
		MATERIAL_DENSITY = 4,
		MATERIAL_HARDNESS = 8,
		MATERIAL_FLEXIBILITY = 1,
		MATERIAL_REFLECTIVITY = 8,
		MATERIAL_ELECTRICAL = 6,
		MATERIAL_THERMAL = 1,
		MATERIAL_CHEMICAL = 8,
	)
	value_per_unit = 0.225
	sheet_type = /obj/item/stack/sheet/mineral/plastitanium
	material_reagent = /datum/reagent/toxin/plasma
	composition = list(/datum/material/titanium = 1, /datum/material/plasma = 1)
	mat_rust_resistance = RUST_RESISTANCE_TITANIUM

/datum/material/alloy/plastitanium/on_applied(atom/source, mat_amount, multiplier, from_slot)
	. = ..()
	if(istype(source, /obj/item/fishing_rod))
		ADD_TRAIT(source, TRAIT_ROD_LAVA_USABLE, REF(src))

/datum/material/alloy/plastitanium/on_removed(atom/source, mat_amount, multiplier, from_slot)
	. = ..()
	if(istype(source, /obj/item/fishing_rod))
		REMOVE_TRAIT(source, TRAIT_ROD_LAVA_USABLE, REF(src))

/**
 * Plasmaglass
 * An alloy of silicate and plasma.
 */
/datum/material/alloy/plasmaglass
	name = "等离子玻璃"
	desc = "等离子体注入的硅酸盐。它比其组成材料中的任何一种都更加耐用和耐热。"
	color = "#ff80f4"
	alpha = 150
	starlight_color = COLOR_STRONG_MAGENTA
	mat_flags = MATERIAL_BASIC_RECIPES | MATERIAL_CLASS_CRYSTAL | MATERIAL_CLASS_RIGID
	mat_properties = list(
		MATERIAL_DENSITY = 5,
		MATERIAL_HARDNESS = 6,
		MATERIAL_FLEXIBILITY = 0,
		MATERIAL_REFLECTIVITY = 8,
		MATERIAL_ELECTRICAL = 0,
		MATERIAL_THERMAL = 2,
		MATERIAL_CHEMICAL = 8,
	)
	sheet_type = /obj/item/stack/sheet/plasmaglass
	shard_type = /obj/item/shard/plasma
	debris_type = /obj/effect/decal/cleanable/glass/plasma
	material_reagent = list(/datum/reagent/silicon = 1, /datum/reagent/toxin/plasma = 0.5)
	value_per_unit = 0.075
	composition = list(/datum/material/glass = 1, /datum/material/plasma = 0.5)

/**
 * Titanium Glass
 * An alloy of glass and titanium.
 */
/datum/material/alloy/titaniumglass
	name = "钛玻璃"
	desc = "一种常用于穿梭机窗户的硅酸盐-钛特种合金。"
	color = "#cfbee0"
	alpha = 150
	starlight_color = COLOR_COMMAND_BLUE
	mat_flags = MATERIAL_BASIC_RECIPES | MATERIAL_CLASS_CRYSTAL | MATERIAL_CLASS_RIGID
	mat_properties = list(
		MATERIAL_DENSITY = 5,
		MATERIAL_HARDNESS = 7,
		MATERIAL_FLEXIBILITY = 0,
		MATERIAL_REFLECTIVITY = 8,
		MATERIAL_ELECTRICAL = 0,
		MATERIAL_THERMAL = 4,
		MATERIAL_CHEMICAL = 8,
	)
	sheet_type = /obj/item/stack/sheet/titaniumglass
	shard_type = /obj/item/shard/titanium
	debris_type = /obj/effect/decal/cleanable/glass/titanium
	material_reagent = /datum/reagent/silicon
	value_per_unit = 0.04
	composition = list(/datum/material/glass = 1, /datum/material/titanium = 0.5)

/**
 * Plastitanium Glass
 * An alloy of plastitanium and glass.
 */
/datum/material/alloy/plastitaniumglass
	name = "塑钛玻璃"
	desc = "一种硅酸盐-塑钛特种合金。"
	color = "#5d3369"
	starlight_color = COLOR_CENTCOM_BLUE
	alpha = 150
	mat_flags = MATERIAL_BASIC_RECIPES | MATERIAL_CLASS_CRYSTAL | MATERIAL_CLASS_RIGID
	mat_properties = list(
		MATERIAL_DENSITY = 4,
		MATERIAL_HARDNESS = 8,
		MATERIAL_FLEXIBILITY = 0,
		MATERIAL_REFLECTIVITY = 8,
		MATERIAL_ELECTRICAL = 0,
		MATERIAL_THERMAL = 2,
		MATERIAL_CHEMICAL = 8,
	)
	sheet_type = /obj/item/stack/sheet/plastitaniumglass
	shard_type = /obj/item/shard/plastitanium
	debris_type = /obj/effect/decal/cleanable/glass/plastitanium
	material_reagent = list(/datum/reagent/silicon = 1, /datum/reagent/toxin/plasma = 0.5)
	value_per_unit = 0.125
	composition = list(/datum/material/glass = 1, /datum/material/alloy/plastitanium = 0.5)

/**
 * Alien Alloy
 * Densified plasteel.
 * Applies a significant slowdown effect to anything that contains it.
 * Anything constructed from it can slowly regenerate.
 */
/datum/material/alloy/alien
	name = "外星合金"
	desc = "一种成分与塑钢相似的极高密度合金。其制造需要特殊的冶金工艺。"
	color = "#6041aa"
	mat_flags = MATERIAL_BASIC_RECIPES | MATERIAL_CLASS_METAL | MATERIAL_CLASS_RIGID
	mat_properties = list(
		MATERIAL_DENSITY = 8,
		MATERIAL_HARDNESS = 8,
		MATERIAL_FLEXIBILITY = 3,
		MATERIAL_REFLECTIVITY = 7,
		MATERIAL_ELECTRICAL = 8,
		MATERIAL_THERMAL = 1,
		MATERIAL_CHEMICAL = 10,
	)
	sheet_type = /obj/item/stack/sheet/mineral/abductor
	material_reagent = list(/datum/reagent/iron = 1, /datum/reagent/toxin/plasma = 1)
	value_per_unit = 0.4
	composition = list(/datum/material/iron = 2, /datum/material/plasma = 2)

/datum/material/alloy/alien/on_applied(atom/source, mat_amount, multiplier, from_slot)
	. = ..()
	if(isobj(source))
		source.AddElement(/datum/element/obj_regen, _rate=0.02) // 2% regen per tick.
	if(istype(source, /obj/item/fishing_rod))
		ADD_TRAIT(source, TRAIT_ROD_LAVA_USABLE, REF(src))

/datum/material/alloy/alien/on_removed(atom/source, mat_amount, multiplier, from_slot)
	. = ..()
	if(isobj(source))
		source.RemoveElement(/datum/element/obj_regen, _rate=0.02)
	if(istype(source, /obj/item/fishing_rod))
		REMOVE_TRAIT(source, TRAIT_ROD_LAVA_USABLE, REF(src))
