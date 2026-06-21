/* Glass stack types
 * Contains:
 * Glass sheets
 * Reinforced glass sheets
 * Glass shards - TODO: Move this into code/game/object/item/weapons
 */

/*
 * Glass sheets
 */
GLOBAL_LIST_INIT(glass_recipes, list ( \
	new/datum/stack_recipe("directional window", /obj/structure/window/unanchored, time = 0.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND | CRAFT_CHECK_DIRECTION, category = CAT_WINDOWS), \
	new/datum/stack_recipe("fulltile window", /obj/structure/window/fulltile/unanchored, 2, time =  1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND | CRAFT_IS_FULLTILE, category = CAT_WINDOWS), \
	new/datum/stack_recipe("glass shard", /obj/item/shard, time = 0, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND, category = CAT_MISC), \
	new/datum/stack_recipe("glass tile", /obj/item/stack/tile/glass, 1, 4, 20, category = CAT_TILES) \
))

/obj/item/stack/sheet/glass
	name = "glass"
	desc = "天哪！这玻璃可真不少。"
	singular_name = "glass sheet"
	icon_state = "sheet-glass"
	inhand_icon_state = "sheet-glass"
	mats_per_unit = list(/datum/material/glass=SHEET_MATERIAL_AMOUNT)
	armor_type = /datum/armor/sheet_glass
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/glass
	material_type = /datum/material/glass
	table_type = /obj/structure/table/glass
	matter_amount = 4
	cost = SHEET_MATERIAL_AMOUNT
	source = /datum/robot_energy_storage/material/glass
	sniffable = TRUE
	pickup_sound = 'sound/items/handling/materials/glass_pick_up.ogg'
	drop_sound = 'sound/items/handling/materials/glass_drop.ogg'

/datum/armor/sheet_glass
	fire = 50
	acid = 100

/obj/item/stack/sheet/glass/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] 开始用 [user.p_their()] \the 切割 [src] 的脖子！看起来 [user.p_theyre()] 想自杀！"))
	return BRUTELOSS

/obj/item/stack/sheet/glass/fifty
	amount = 50

/obj/item/stack/sheet/glass/get_main_recipes()
	. = ..()
	. += GLOB.glass_recipes

/obj/item/stack/sheet/glass/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	add_fingerprint(user)
	if(istype(W, /obj/item/lightreplacer))
		var/obj/item/lightreplacer/lightreplacer = W
		lightreplacer.attackby(src, user)
	if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if (get_amount() < 1 || CC.get_amount() < 5)
			to_chat(user, span_warning("你需要五段线圈和一张玻璃板来制作铁丝玻璃！"))
			return
		CC.use(5)
		use(1)
		to_chat(user, span_notice("你将电线连接到 \the [src] 上。"))
		var/obj/item/stack/light_w/new_tile = new(user.loc)
		if (!QDELETED(new_tile))
			new_tile.add_fingerprint(user)
		return
	if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/V = W
		if (V.get_amount() >= 1 && get_amount() >= 1)
			var/obj/item/stack/sheet/rglass/RG = new (get_turf(user))
			if(!QDELETED(RG))
				RG.add_fingerprint(user)
			var/replace = user.get_inactive_held_item() == src
			V.use(1)
			use(1)
			if(QDELETED(src) && replace && !QDELETED(RG))
				user.put_in_hands(RG)
		else
			to_chat(user, span_warning("你需要一根棒和一张玻璃板来制作强化玻璃！"))
		return
	return ..()

GLOBAL_LIST_INIT(pglass_recipes, list ( \
	new/datum/stack_recipe("directional window", /obj/structure/window/plasma/unanchored, time = 0.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND | CRAFT_CHECK_DIRECTION, category = CAT_WINDOWS), \
	new/datum/stack_recipe("fulltile window", /obj/structure/window/plasma/fulltile/unanchored, 2, time = 2 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND | CRAFT_IS_FULLTILE, category = CAT_WINDOWS), \
	new/datum/stack_recipe("plasma glass shard", /obj/item/shard/plasma, time = 20, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND, category = CAT_MISC), \
	new/datum/stack_recipe("plasma glass tile", /obj/item/stack/tile/glass/plasma, 1, 4, 20, category = CAT_TILES) \
))

/obj/item/stack/sheet/plasmaglass
	name = "等离子玻璃"
	desc = "由等离子体-硅酸盐合金制成的玻璃板。看起来极其坚固且高度耐火。"
	singular_name = "plasma glass sheet"
	icon_state = "sheet-pglass"
	inhand_icon_state = "sheet-pglass"
	mats_per_unit = list(/datum/material/alloy/plasmaglass=SHEET_MATERIAL_AMOUNT)
	material_type = /datum/material/alloy/plasmaglass
	armor_type = /datum/armor/sheet_plasmaglass
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/plasmaglass
	material_flags = NONE
	table_type = /obj/structure/table/glass/plasmaglass
	pickup_sound = 'sound/items/handling/materials/glass_pick_up.ogg'
	drop_sound = 'sound/items/handling/materials/glass_drop.ogg'

/obj/item/stack/sheet/plasmaglass/fifty
	amount = 50

/datum/armor/sheet_plasmaglass
	fire = 75
	acid = 100

/obj/item/stack/sheet/plasmaglass/get_main_recipes()
	. = ..()
	. += GLOB.pglass_recipes

/obj/item/stack/sheet/plasmaglass/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	add_fingerprint(user)

	if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/V = W
		if (V.get_amount() >= 1 && get_amount() >= 1)
			var/obj/item/stack/sheet/plasmarglass/RG = new (get_turf(user))
			if (!QDELETED(RG))
				RG.add_fingerprint(user)
			var/replace = user.get_inactive_held_item() == src
			V.use(1)
			use(1)
			if(QDELETED(src) && replace)
				user.put_in_hands(RG)
		else
			to_chat(user, span_warning("你需要一根棒和一张等离子玻璃板来制作强化等离子玻璃！"))
			return
	else
		return ..()

/*
 * Reinforced glass sheets
 */
GLOBAL_LIST_INIT(reinforced_glass_recipes, list ( \
	new/datum/stack_recipe("windoor frame", /obj/structure/windoor_assembly, 5, time = 0, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND | CRAFT_CHECK_DIRECTION, category = CAT_WINDOWS), \
	null, \
	new/datum/stack_recipe("directional reinforced window", /obj/structure/window/reinforced/unanchored, time = 0.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND | CRAFT_CHECK_DIRECTION, category = CAT_WINDOWS), \
	new/datum/stack_recipe("fulltile reinforced window", /obj/structure/window/reinforced/fulltile/unanchored, 2, time = 2 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND | CRAFT_IS_FULLTILE, category = CAT_WINDOWS), \
	new/datum/stack_recipe("glass shard", /obj/item/shard, time = 10, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND | CRAFT_SKIP_MATERIALS_PARITY, category = CAT_MISC), \
	new/datum/stack_recipe("reinforced glass tile", /obj/item/stack/tile/rglass, 1, 4, 20, category = CAT_TILES) \
))


/obj/item/stack/sheet/rglass
	name = "强化玻璃"
	desc = "看起来里面嵌入了棒状物或其他东西的玻璃。"
	singular_name = "reinforced glass sheet"
	icon_state = "sheet-rglass"
	inhand_icon_state = "sheet-rglass"
	mats_per_unit = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT * 0.5, /datum/material/glass=SHEET_MATERIAL_AMOUNT)
	armor_type = /datum/armor/sheet_rglass
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/rglass
	matter_amount = 6
	table_type = /obj/structure/table/reinforced/rglass
	pickup_sound = 'sound/items/handling/materials/glass_pick_up.ogg'
	drop_sound = 'sound/items/handling/materials/glass_drop.ogg'

/obj/item/stack/sheet/rglass/grind_results()
	return list(/datum/reagent/silicon = 10, /datum/reagent/iron = 10)

/obj/item/stack/sheet/rglass/fifty
	amount = 50

/datum/armor/sheet_rglass
	fire = 70
	acid = 100

/obj/item/stack/sheet/rglass/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	add_fingerprint(user)
	..()

/obj/item/stack/sheet/rglass/get_main_recipes()
	. = ..()
	. += GLOB.reinforced_glass_recipes

GLOBAL_LIST_INIT(prglass_recipes, list ( \
	new/datum/stack_recipe("directional reinforced window", /obj/structure/window/reinforced/plasma/unanchored, time = 0.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND | CRAFT_CHECK_DIRECTION, category = CAT_WINDOWS), \
	new/datum/stack_recipe("fulltile reinforced window", /obj/structure/window/reinforced/plasma/fulltile/unanchored, 2, time = 2 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND | CRAFT_IS_FULLTILE, category = CAT_WINDOWS), \
	new/datum/stack_recipe("plasma glass shard", /obj/item/shard/plasma, time = 40, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND | CRAFT_SKIP_MATERIALS_PARITY, category = CAT_MISC), \
	new/datum/stack_recipe("reinforced plasma glass tile", /obj/item/stack/tile/rglass/plasma, 1, 4, 20, category = CAT_TILES) \
))

/obj/item/stack/sheet/plasmarglass
	name = "强化等离子玻璃"
	desc = "由等离子体-硅酸盐合金和棒状矩阵制成的玻璃板。看起来无比坚固且近乎防火！"
	singular_name = "reinforced plasma glass sheet"
	icon_state = "sheet-prglass"
	inhand_icon_state = "sheet-prglass"
	mats_per_unit = list(/datum/material/alloy/plasmaglass=SHEET_MATERIAL_AMOUNT, /datum/material/iron = SHEET_MATERIAL_AMOUNT * 0.5)
	armor_type = /datum/armor/sheet_plasmarglass
	resistance_flags = ACID_PROOF
	material_flags = NONE
	merge_type = /obj/item/stack/sheet/plasmarglass
	gulag_valid = TRUE
	matter_amount = 8
	table_type = /obj/structure/table/reinforced/plasmarglass
	pickup_sound = 'sound/items/handling/materials/glass_pick_up.ogg'
	drop_sound = 'sound/items/handling/materials/glass_drop.ogg'

/obj/item/stack/sheet/plasmarglass/grind_results()
	return list(/datum/reagent/silicon = 10, /datum/reagent/toxin/plasma = 10, /datum/reagent/iron = 10)

/datum/armor/sheet_plasmarglass
	melee = 20
	fire = 80
	acid = 100

/obj/item/stack/sheet/plasmarglass/fifty
	amount = 50

/obj/item/stack/sheet/plasmarglass/get_main_recipes()
	. = ..()
	. += GLOB.prglass_recipes

GLOBAL_LIST_INIT(titaniumglass_recipes, list(
	new/datum/stack_recipe("shuttle window", /obj/structure/window/reinforced/shuttle/unanchored, 2, time = 0.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND | CRAFT_CHECK_DIRECTION | CRAFT_IS_FULLTILE, category = CAT_WINDOWS), \
	new/datum/stack_recipe("titanium glass shard", /obj/item/shard/titanium, time = 40, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND, category = CAT_MISC) \
	))

/obj/item/stack/sheet/titaniumglass
	name = "钛玻璃"
	desc = "由钛-硅酸盐合金制成的玻璃板。"
	singular_name = "titanium glass sheet"
	icon_state = "sheet-titaniumglass"
	inhand_icon_state = "sheet-titaniumglass"
	mats_per_unit = list(/datum/material/alloy/titaniumglass=SHEET_MATERIAL_AMOUNT)
	material_type = /datum/material/alloy/titaniumglass
	armor_type = /datum/armor/sheet_titaniumglass
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/titaniumglass
	table_type = /obj/structure/table/reinforced/titaniumglass
	pickup_sound = 'sound/items/handling/materials/glass_pick_up.ogg'
	drop_sound = 'sound/items/handling/materials/glass_drop.ogg'

/obj/item/stack/sheet/titaniumglass/fifty
	amount = 50

/datum/armor/sheet_titaniumglass
	fire = 80
	acid = 100

/obj/item/stack/sheet/titaniumglass/get_main_recipes()
	. = ..()
	. += GLOB.titaniumglass_recipes

GLOBAL_LIST_INIT(plastitaniumglass_recipes, list(
	new/datum/stack_recipe("plastitanium window", /obj/structure/window/reinforced/plasma/plastitanium/unanchored, 2, time = 2 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND | CRAFT_IS_FULLTILE, category = CAT_WINDOWS), \
	new/datum/stack_recipe("plastitanium glass shard", /obj/item/shard/plastitanium, time = 60, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND, category = CAT_MISC) \
	))

/obj/item/stack/sheet/plastitaniumglass
	name = "等离子钛玻璃"
	desc = "由等离子体-钛-硅酸盐合金制成的玻璃板。"
	singular_name = "plastitanium glass sheet"
	icon_state = "sheet-plastitaniumglass"
	inhand_icon_state = "sheet-plastitaniumglass"
	mats_per_unit = list(/datum/material/alloy/plastitaniumglass=SHEET_MATERIAL_AMOUNT)
	material_type = /datum/material/alloy/plastitaniumglass
	armor_type = /datum/armor/sheet_plastitaniumglass
	material_flags = NONE
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/plastitaniumglass
	table_type = /obj/structure/table/reinforced/plastitaniumglass
	pickup_sound = 'sound/items/handling/materials/glass_pick_up.ogg'
	drop_sound = 'sound/items/handling/materials/glass_drop.ogg'

/obj/item/stack/sheet/plastitaniumglass/fifty
	amount = 50

/datum/armor/sheet_plastitaniumglass
	fire = 80
	acid = 100

/obj/item/stack/sheet/plastitaniumglass/get_main_recipes()
	. = ..()
	. += GLOB.plastitaniumglass_recipes

/obj/item/shard
	name = "玻璃碎片"
	desc = "一块看起来很不妙的玻璃碎片。"
	icon = 'icons/obj/debris.dmi'
	icon_state = "large"
	icon_angle = -45
	w_class = WEIGHT_CLASS_TINY
	force = 5
	throwforce = 10
	inhand_icon_state = "shard-glass"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	custom_materials = list(/datum/material/glass=SHEET_MATERIAL_AMOUNT)
	attack_verb_continuous = list("stabs", "slashes", "slices", "cuts")
	attack_verb_simple = list("stab", "slash", "slice", "cut")
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	resistance_flags = ACID_PROOF
	armor_type = /datum/armor/item_shard
	max_integrity = 40
	sharpness = SHARP_EDGED
	var/icon_prefix
	var/shiv_type = /obj/item/knife/shiv
	var/craft_time = 3.5 SECONDS
	var/obj/item/stack/sheet/weld_material = /obj/item/stack/sheet/glass
	embed_type = /datum/embedding/shard

/datum/embedding/shard
	embed_chance = 65

/datum/armor/item_shard
	melee = 100
	energy = 100
	fire = 50
	acid = 100

/obj/item/shard/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 正用玻璃碎片割开[user.p_their()]的[pick("wrists", "throat")]！看起来[user.p_theyre()]想自杀。"))
	return BRUTELOSS

/obj/item/shard/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/caltrop, min_damage = force)
	AddComponent(/datum/component/butchering, \
	speed = 15 SECONDS, \
	effectiveness = 65, \
	)
	icon_state = pick("large", "medium", "small")
	switch(icon_state)
		if("small")
			pixel_x = rand(-12, 12)
			pixel_y = rand(-12, 12)
		if("medium")
			pixel_x = rand(-8, 8)
			pixel_y = rand(-8, 8)
		if("large")
			pixel_x = rand(-5, 5)
			pixel_y = rand(-5, 5)
	if (icon_prefix)
		icon_state = "[icon_prefix][icon_state]"

	var/turf/T = get_turf(src)
	if(T && is_station_level(T.z))
		SSblackbox.record_feedback("tally", "station_mess_created", 1, name)
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/item/shard/Destroy()
	. = ..()

	var/turf/T = get_turf(src)
	if(T && is_station_level(T.z))
		SSblackbox.record_feedback("tally", "station_mess_destroyed", 1, name)

/obj/item/shard/afterattack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	if(!iscarbon(user) || !user.is_holding(src))
		return

	var/mob/living/carbon/jab = user
	if(jab.get_all_covered_flags() & HANDS)
		return

	to_chat(user, span_warning("[src] 割伤了你的手！"))
	jab.apply_damage(force * 0.5, BRUTE, user.get_active_hand(), attacking_item = src)

/obj/item/shard/attackby(obj/item/item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(item, /obj/item/lightreplacer))
		var/obj/item/lightreplacer/lightreplacer = item
		lightreplacer.attackby(src, user)
	else if(istype(item, /obj/item/stack/sheet/cloth))
		var/obj/item/stack/sheet/cloth/cloth = item
		to_chat(user, span_notice("你开始将[cloth]缠绕在[src]上..."))
		if(do_after(user, craft_time, target = src))
			var/obj/item/knife/shiv/shiv = new shiv_type
			shiv.set_custom_materials(custom_materials)
			cloth.use(1)
			to_chat(user, span_notice("你将[cloth]缠绕在[src]上，做成了一件临时武器。"))
			remove_item_from_storage(src, user)
			qdel(src)
			user.put_in_hands(shiv)

	else
		return ..()

/obj/item/shard/welder_act(mob/living/user, obj/item/I)
	if(I.use_tool(src, user, 0, volume=50))
		var/obj/item/stack/sheet/new_glass = new weld_material
		to_chat(user, span_notice("你将[src]熔化成[new_glass.name]。"))
		new_glass.forceMove((Adjacent(user) ? user.drop_location() : loc)) //stack merging is handled automatically.
		qdel(src)
		return ITEM_INTERACT_SUCCESS

/obj/item/shard/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(isliving(AM))
		var/mob/living/L = AM
		if(!(L.movement_type & MOVETYPES_NOT_TOUCHING_GROUND) || L.buckled)
			playsound(src, 'sound/effects/footstep/glass_step.ogg', HAS_TRAIT(L, TRAIT_LIGHT_STEP) ? 30 : 50, TRUE)

/obj/item/shard/plasma
	name = "紫色碎片"
	desc = "一块看起来很不祥的等离子玻璃碎片。"
	force = 6
	throwforce = 11
	icon_state = "plasmalarge"
	inhand_icon_state = "shard-plasma"
	custom_materials = list(/datum/material/alloy/plasmaglass=SHEET_MATERIAL_AMOUNT)
	icon_prefix = "plasma"
	weld_material = /obj/item/stack/sheet/plasmaglass
	shiv_type = /obj/item/knife/shiv/plasma
	craft_time = 7 SECONDS

/obj/item/shard/titanium
	name = "明亮碎片"
	desc = "一块难看的钛合金玻璃碎片。"
	throwforce = 12
	icon_state = "titaniumlarge"
	inhand_icon_state = "shard-titanium"
	custom_materials = list(/datum/material/alloy/titaniumglass=SHEET_MATERIAL_AMOUNT)
	icon_prefix = "titanium"
	weld_material = /obj/item/stack/sheet/titaniumglass
	shiv_type = /obj/item/knife/shiv/titanium
	craft_time = 7 SECONDS

/obj/item/shard/plastitanium
	name = "暗色碎片"
	desc = "一块难看的、注入钛的等离子玻璃碎片。"
	force = 7
	throwforce = 12
	icon_state = "plastitaniumlarge"
	inhand_icon_state = "shard-plastitanium"
	custom_materials = list(/datum/material/alloy/plastitaniumglass=SHEET_MATERIAL_AMOUNT)
	icon_prefix = "plastitanium"
	weld_material = /obj/item/stack/sheet/plastitaniumglass
	shiv_type = /obj/item/knife/shiv/plastitanium
	craft_time = 14 SECONDS
